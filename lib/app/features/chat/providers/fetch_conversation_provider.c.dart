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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_conversation_provider.c.g.dart';

@Riverpod(keepAlive: true)
class FetchConversations extends _$FetchConversations {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> fetchAndSync() async {
    final pubkey = await ref.read(currentPubkeySelectorProvider.future);
    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final currentUserSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);
    if (currentUserSigner == null) {
      throw EventSignerNotFoundException();
    }

    final lastMessageDate =
        await ref.read(conversationsDBServiceProvider).getLastConversationMessageCreatedAt();

    final sinceDate = lastMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      kinds: const [1059],
      k: [
        PrivateDirectMessageEntity.kind.toString(),
        PrivateMessageReactionEntity.kind.toString(),
      ],
      p: [pubkey],
      since: sinceDate,
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final events = ref.read(ionConnectNotifierProvider.notifier).requestEvents(
          requestMessage,
          actionSource: const ActionSourceCurrentUserChat(),
          keepSubscription: true,
        );

    final dbProvider = ref.read(conversationsDBServiceProvider);

    try {
      await for (final event in events) {
        final unwrappedGift = await ref.read(ionConnectGiftWrapServiceProvider).decodeWrap(
              event.content,
              pubkey,
              currentUserSigner,
            );

        final unwrappedSeal = await ref.read(ionConnectSealServiceProvider).decodeSeal(
              unwrappedGift,
              currentUserSigner,
              pubkey,
            );

        await dbProvider.insertEventMessage(unwrappedSeal);
      }
    } catch (_) {
      throw FetchAndSyncConversationsException();
    }
  }
}
