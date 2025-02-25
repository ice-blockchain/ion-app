// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_messages_subscriber.c.g.dart';

@riverpod
class E2eeMessagesSubscriber extends _$E2eeMessagesSubscriber {
  @override
  Stream<void> build() async* {
    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    if (masterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final latestEventMessageDate = await ref
        .watch(conversationEventMessageDaoProvider)
        .getLatestEventMessageDate(PrivateDirectMessageEntity.kind);

    final sinceDate = latestEventMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapServiceImpl.kind],
      tags: {
        '#k': [
          DeletionRequest.kind.toString(),
          PrivateDirectMessageEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
        ],
        '#p': [
          masterPubkey,
        ],
      },
      since: sinceDate,
    );
    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final sealService = await ref.watch(ionConnectSealServiceProvider.future);
    final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
    final sendE2eeMessageService = await ref.watch(sendE2eeMessageServiceProvider.future);
    final conversationMessageStatusDao = ref.watch(conversationMessageDataDaoProvider);
    final conversationMessageReactionDao = ref.watch(conversationMessageReactionDaoProvider);

    ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
      requestMessage,
      actionSource: const ActionSourceCurrentUserChat(),
      subscriptionBuilder: (requestMessage, relay) {
        final subscription = relay.subscribe(requestMessage);
        ref.onDispose(() {
          try {
            relay.unsubscribe(subscription.id);
          } catch (error, stackTrace) {
            Logger.log('Failed to unsubscribe', error: error, stackTrace: stackTrace);
          }
        });
        return subscription.messages;
      },
    ).listen((wrap) async {
      if (eventSigner.publicKey != _receiverDevicePubkey(wrap)) {
        return;
      }

      final rumor = await _unwrapGift(
        giftWrap: wrap,
        sealService: sealService,
        giftWrapService: giftWrapService,
        privateKey: eventSigner.privateKey,
      );

      if (rumor != null) {
        if (rumor.tags.any((tag) => tag[0] == CommunityIdentifierTag.tagName) ||
            rumor.kind == PrivateMessageReactionEntity.kind) {
          // Try to get kind 14 event id from related event tag or use the rumor id
          final kind14EventId = rumor.kind == PrivateMessageReactionEntity.kind
              ? rumor.tags
                  .firstWhereOrNull((tags) => tags[0] == RelatedImmutableEvent.tagName)
                  ?.elementAtOrNull(1)
              : rumor.id;
          // Try to get sender master pubkey from tags ('b' tag present in all events)
          final rumorMasterPubkey =
              rumor.tags.firstWhereOrNull((tags) => tags[0] == 'b')?.elementAtOrNull(1);

          if (kind14EventId == null || rumorMasterPubkey == null) {
            throw ReceiverDevicePubkeyNotFoundException(rumor.id);
          }

          // Only for kind 14
          if (rumor.kind == PrivateDirectMessageEntity.kind) {
            // Add conversation if that doesn't exist
            await ref.watch(conversationDaoProvider).add([rumor]);
            // Add message if that doesn't exist
            await ref.watch(conversationEventMessageDaoProvider).add(rumor);
            // If user received another user message add "received" status
            // for them both into the database, we don't know anything about
            // other users in the conversation
            //final sendTo = {masterPubkey, rumorMasterPubkey};

            // Notify rest of the participants that the message was received
            // by the current user
            final currentStatus = await conversationMessageStatusDao.checkMessageStatus(
              masterPubkey: masterPubkey,
              eventMessageId: kind14EventId,
            );

            if (currentStatus == null ||
                currentStatus.index < MessageDeliveryStatus.received.index) {
              await sendE2eeMessageService.sendMessageStatus(rumor, MessageDeliveryStatus.received);
            }

            // Only for kind 7
          } else if (rumor.kind == PrivateMessageReactionEntity.kind) {
            // Identify kind 7 status message (received or read only)
            if (rumor.content == MessageDeliveryStatus.received.name ||
                rumor.content == MessageDeliveryStatus.read.name) {
              final status = rumor.content == MessageDeliveryStatus.received.name
                  ? MessageDeliveryStatus.received
                  : MessageDeliveryStatus.read;

              // Add corresponding status to the database for the sender master pubkey
              // and the kind 14 event id, if that doesn't exist
              await conversationMessageStatusDao.add(
                status: status,
                createdAt: rumor.createdAt,
                eventMessageId: kind14EventId,
                masterPubkey: rumorMasterPubkey,
              );
            } else {
              await conversationMessageReactionDao.add(
                ref: ref,
                newReactionEvent: rumor,
                kind14EventId: kind14EventId,
                masterPubkey: rumorMasterPubkey,
              );
            }
          }
          // For kind 5
        } else if (rumor.kind == DeletionRequest.kind) {
          await conversationMessageReactionDao.remove(
            ref: ref,
            removalRequest: rumor,
          );
        }
      }
    });

    yield null;
  }

  String _receiverDevicePubkey(EventMessage wrap) {
    final senderPubkey = wrap.tags.firstWhereOrNull((tags) => tags[0] == 'p')?.elementAtOrNull(3);

    if (senderPubkey == null) {
      throw ReceiverDevicePubkeyNotFoundException(wrap.id);
    }

    return senderPubkey;
  }

  Future<EventMessage?> _unwrapGift({
    required EventMessage giftWrap,
    required String privateKey,
    required IonConnectSealService sealService,
    required IonConnectGiftWrapService giftWrapService,
  }) async {
    try {
      final seal = await giftWrapService.decodeWrap(
        privateKey: privateKey,
        content: giftWrap.content,
        senderPubkey: giftWrap.pubkey,
      );

      return await sealService.decodeSeal(
        seal.content,
        seal.pubkey,
        privateKey,
      );
    } catch (e) {
      throw DecodeE2EMessageException(giftWrap.id);
    }
  }
}
