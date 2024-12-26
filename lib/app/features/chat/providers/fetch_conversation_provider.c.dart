// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_signer_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/services/database/ion_database.c.dart';
import 'package:ion/app/services/nostr/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/nostr/ion_connect_seal_service.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_conversation_provider.c.g.dart';

@riverpod
class FetchConversations extends _$FetchConversations {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> fetchAndSync() async {
    final pubkey = ref.read(currentPubkeySelectorProvider);
    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final currentUserSigner = await ref.read(currentUserNostrEventSignerProvider.future);
    if (currentUserSigner == null) {
      throw EventSignerNotFoundException();
    }

    final lastMessageDate = await ref
        .read(dBConversationsNotifierProvider.notifier)
        .getLastConversationMessageCreatedAt();

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

    final events = ref.read(nostrNotifierProvider.notifier).requestEvents(
          requestMessage,
          actionSource: const ActionSourceCurrentUserChat(),
          keepSubscription: true,
        );

    final dbProvider = ref.read(dBConversationsNotifierProvider.notifier);

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
