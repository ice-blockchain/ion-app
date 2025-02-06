// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
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

part 'fetch_conversation_provider.c.g.dart';

@riverpod
class FetchConversations extends _$FetchConversations {
  @override
  Stream<void> build() async* {
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final pubkey = eventSigner.publicKey;

    // final lastMessageDate =
    //     await ref.watch(conversationsDBServiceProvider).getLastConversationMessageCreatedAt();

    // final sinceDate = lastMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapServiceImpl.kind],
      tags: {
        '#k': [
          PrivateDirectMessageEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
        ],
        '#p': [masterPubkey],
      },
      // since: sinceDate,
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final sealService = await ref.watch(ionConnectSealServiceProvider.future);
    final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);

    final wrapEvents = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
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
    );

    await for (final wrap in wrapEvents) {
      if (eventSigner.publicKey != _receiverDevicePubkey(wrap)) {
        continue;
      }
      final rumor = await _unwrapGift(
        wrap,
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
}
