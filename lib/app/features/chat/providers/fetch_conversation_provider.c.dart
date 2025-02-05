// SPDX-License-Identifier: ice License 1.0

import 'dart:developer';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
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
  Future<void> build() async {
    final masterPubkey = await ref.watch(currentPubkeySelectorProvider.future);
    final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

    if (masterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final lastMessageDate = await ref.watch(conversationsDBServiceProvider).getLastConversationMessageCreatedAt();

    final sinceDate = lastMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapServiceImpl.kind],
      tags: {
        '#k': [
          PrivateDirectMessageEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
        ],
        '#p': [eventSigner.publicKey],
      },
      since: sinceDate,
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

    final dbProvider = ref.watch(conversationsDBServiceProvider);

    await for (final giftwrap in wrapEvents) {
      log(giftwrap.toString());
      final rumor = await _unwrapGift(
        giftWrap: giftwrap,
        sealService: sealService,
        giftWrapService: giftWrapService,
        privateKey: eventSigner.privateKey,
      );
      if (rumor != null) {
        await dbProvider.insertEventMessage(rumor);
      }
    }
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
        senderPubkey: giftWrap.senderDevicePubkey,
      );

      return await sealService.decodeSeal(
        seal.content,
        seal.pubkey,
        privateKey,
      );
    } catch (error, stackTrace) {
      Logger.log(DecodeE2EMessageException().toString(), error: error, stackTrace: stackTrace);
    }
    return null;
  }
}
