// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_messages_subscriber.c.g.dart';

@Riverpod(keepAlive: true)
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
        .getLatestEventMessageDate([ReplaceablePrivateDirectMessageEntity.kind]);

    final userChatRelays = await ref.watch(userChatRelaysProvider(masterPubkey).future);

    if (userChatRelays == null) {
      return;
    }

    final sinceDate = latestEventMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapServiceImpl.kind],
      tags: {
        '#k': [
          DeletionRequestEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
          ReplaceablePrivateDirectMessageEntity.kind.toString(),
          [GenericRepostEntity.kind.toString(), ModifiablePostEntity.kind.toString()],
        ],
        '#p': [masterPubkey],
      },
      since: sinceDate,
    );

    final sealService = await ref.watch(ionConnectSealServiceProvider.future);
    final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
    final sendE2eeMessageService = await ref.watch(sendE2eeMessageServiceProvider.future);
    final conversationDao = ref.watch(conversationDaoProvider);
    final eventMessageDao = ref.watch(eventMessageDaoProvider);
    final conversationMessageDao = ref.watch(conversationMessageDaoProvider);
    final conversationMessageStatusDao = ref.watch(conversationMessageDataDaoProvider);
    final conversationMessageReactionDao = ref.watch(conversationMessageReactionDaoProvider);

    await ref.watch(entitiesSyncerNotifierProvider('e2ee-messages').notifier).syncEvents(
      requestFilters: [requestFilter],
      saveCallback: (eventMessage) => _handleMessage(
        eventMessage,
        masterPubkey,
        eventSigner,
        sealService,
        giftWrapService,
        sendE2eeMessageService,
        conversationDao,
        eventMessageDao,
        conversationMessageDao,
        conversationMessageStatusDao,
        conversationMessageReactionDao,
      ),
      maxCreatedAtBuilder: () => ref
          .watch(conversationEventMessageDaoProvider)
          .getLatestEventMessageDate([ReplaceablePrivateDirectMessageEntity.kind]),
      minCreatedAtBuilder: (since) =>
          ref.watch(conversationEventMessageDaoProvider).getEarliestEventMessageDate(
        [ReplaceablePrivateDirectMessageEntity.kind],
        after: since,
      ),
      overlap: const Duration(days: 2),
      actionSource: const ActionSourceCurrentUserChat(),
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    // TODO Clear expired and deleted database messages later

    final events = ref.watch(
      ionConnectEventsSubscriptionProvider(
        requestMessage,
        actionSource: const ActionSourceCurrentUserChat(),
      ),
    );

    final subscription = events.listen(
      (wrap) => _handleMessage(
        wrap,
        masterPubkey,
        eventSigner,
        sealService,
        giftWrapService,
        sendE2eeMessageService,
        conversationDao,
        eventMessageDao,
        conversationMessageDao,
        conversationMessageStatusDao,
        conversationMessageReactionDao,
      ),
    );

    ref.onDispose(subscription.cancel);

    yield null;
  }

  Future<void> _handleMessage(
    EventMessage eventMessage,
    String masterPubkey,
    EventSigner eventSigner,
    IonConnectSealService sealService,
    IonConnectGiftWrapService giftWrapService,
    SendE2eeMessageService sendE2eeMessageService,
    ConversationDao conversationDao,
    EventMessageDao eventMessageDao,
    ConversationMessageDao conversationMessageDao,
    ConversationMessageDataDao conversationMessageStatusDao,
    ConversationMessageReactionDao conversationMessageReactionDao,
  ) async {
    if (eventSigner.publicKey != _receiverDevicePubkey(eventMessage)) {
      return;
    }

    final rumor = await _unwrapGift(
      giftWrap: eventMessage,
      sealService: sealService,
      giftWrapService: giftWrapService,
      privateKey: eventSigner.privateKey,
    );

    if (rumor != null) {
      if (rumor.kind != DeletionRequestEntity.kind &&
          rumor.kind != GenericRepostEntity.kind &&
          (rumor.tags.any((tag) => tag[0] == ConversationIdentifier.tagName) ||
              rumor.kind == PrivateMessageReactionEntity.kind)) {
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

        // Only for kind 30014
        if (rumor.kind == ReplaceablePrivateDirectMessageEntity.kind) {
          // Add conversation if that doesn't exist
          await ref.watch(conversationDaoProvider).add([rumor]);
          // Add message if that doesn't exist
          await ref.watch(conversationEventMessageDaoProvider).add(rumor);

          await _addMediaToDatabase(rumor);

          // If user received another user message add "received" status
          // for them both into the database, we don't know anything about
          // other users in the conversation
          //final sendTo = {masterPubkey, rumorMasterPubkey};

          // Notify rest of the participants that the message was received
          // by the current user
          final currentStatus = await conversationMessageStatusDao.checkMessageStatus(
            sharedId: rumor.sharedId!,
            masterPubkey: masterPubkey,
          );

          if (currentStatus == null || currentStatus.index < MessageDeliveryStatus.received.index) {
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
            if (rumor.sharedId != null) {
              await conversationMessageStatusDao.add(
                status: status,
                pubkey: rumor.pubkey,
                sharedId: rumor.sharedId!,
                masterPubkey: rumorMasterPubkey,
              );
            }
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
      } else if (rumor.kind == DeletionRequestEntity.kind) {
        final deleteEventKind =
            rumor.tags.firstWhereOrNull((tags) => tags[0] == 'k')?.elementAtOrNull(1);

        final deleteEventIds = rumor.tags
            .where((tags) => tags[0] == RelatedImmutableEvent.tagName)
            .map((tag) => tag.elementAtOrNull(1))
            .nonNulls
            .toList();

        final deleteConversationIds = rumor.tags
            .where((tags) => tags[0] == ConversationIdentifier.tagName)
            .map((tag) => tag.elementAtOrNull(1))
            .nonNulls
            .toList();

        if (deleteConversationIds.isNotEmpty) {
          await conversationDao.removeConversations(
            ref: ref,
            deleteRequest: rumor,
            conversationIds: deleteConversationIds,
          );
        } else if (deleteEventKind == ReplaceablePrivateDirectMessageEntity.kind.toString() ||
            deleteEventKind == ReplaceablePrivateDirectMessageEntity.kind.toString()) {
          if (deleteEventIds.isNotEmpty) {
            await conversationMessageDao.removeMessages(
              ref: ref,
              deleteRequest: rumor,
              messageIds: deleteEventIds,
            );
          }
        } else if (deleteEventKind == PrivateMessageReactionEntity.kind.toString()) {
          await conversationMessageReactionDao.remove(
            ref: ref,
            deleteRequest: rumor,
            reactionEventId: deleteEventIds.single,
          );
        }
      } else if (rumor.kind == GenericRepostEntity.kind) {
        await eventMessageDao.add(rumor);
      }
    }
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

  Future<void> _addMediaToDatabase(
    EventMessage rumor,
  ) async {
    final entity = PrivateDirectMessageEntity.fromEventMessage(rumor);
    if (entity.data.media.isNotEmpty) {
      for (final media in entity.data.media.values) {
        await ref
            .read(mediaEncryptionServiceProvider)
            .retrieveEncryptedMedia(media, authorPubkey: rumor.masterPubkey);
        final isThumb =
            entity.data.media.values.any((m) => m.url != media.url && m.thumb == media.url);

        if (isThumb) {
          continue;
        }
        await ref.watch(messageMediaDaoProvider).add(
              eventMessageId: rumor.id,
              status: MessageMediaStatus.completed,
              remoteUrl: media.url,
            );
      }
    }
  }
}
