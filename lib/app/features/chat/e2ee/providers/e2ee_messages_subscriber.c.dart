// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_message_reaction_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
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
    final masterPubkey = await ref.watch(currentPubkeySelectorProvider.future);
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

    if (masterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final latestEventMessageDate = await ref
        .watch(conversationTableDaoProvider)
        .getLatestEventMessageDate(PrivateDirectMessageEntity.kind);

    final sinceDate = latestEventMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapServiceImpl.kind],
      tags: {
        '#k': [
          PrivateDirectMessageEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
        ],
        '#p': [masterPubkey],
      },
      since: sinceDate,
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final sealService = await ref.watch(ionConnectSealServiceProvider.future);
    final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);

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
        if (rumor.tags.any((tag) => tag[0] == CommunityIdentifierTag.tagName)) {
          if (rumor.kind == PrivateDirectMessageEntity.kind) {
            await ref.watch(conversationTableDaoProvider).add([rumor]);
          }
          await ref.watch(eventMessageTableDaoProvider).add(rumor);
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
