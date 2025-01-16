// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_conversation_provider.c.g.dart';

@riverpod
class FetchConversations extends _$FetchConversations {
  @override
  Future<void> build() async {
    final pubkey = await ref.watch(currentPubkeySelectorProvider.future);
    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final lastMessageDate =
        await ref.watch(conversationsDBServiceProvider).getLastConversationMessageCreatedAt();

    final sinceDate = lastMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapServiceImpl.kind],
      k: [
        PrivateDirectMessageEntity.kind.toString(),
        PrivateMessageReactionEntity.kind.toString(),
      ],
      p: [pubkey],
      since: sinceDate,
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final events = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
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

    await for (final event in events) {
      final rumor = await _unwrapGift(event, pubkey: pubkey);
      if (rumor != null) {
        await dbProvider.insertEventMessage(rumor);
      }
    }
  }

  Future<EventMessage?> _unwrapGift(EventMessage giftWrap, {required String pubkey}) async {
    final currentUserSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);
    if (currentUserSigner == null) {
      throw EventSignerNotFoundException();
    }

    try {
      final seal = await ref.read(ionConnectGiftWrapServiceProvider).decodeWrap(
            giftWrap.content,
            pubkey,
            currentUserSigner,
          );

      return await ref.read(ionConnectSealServiceProvider).decodeSeal(
            seal,
            currentUserSigner,
            pubkey,
          );
    } catch (error, stackTrace) {
      Logger.log(DecodeE2EMessageException().toString(), error: error, stackTrace: stackTrace);
    }
    return null;
  }
}
