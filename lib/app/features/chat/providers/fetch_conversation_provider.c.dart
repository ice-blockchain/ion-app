import 'package:hooks_riverpod/hooks_riverpod.dart';
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
Future<void> fetchAndSyncConversations(Ref ref) async {
  final pubkey = ref.read(currentPubkeySelectorProvider);
  if (pubkey == null) {
    return;
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

  final nostrEvents = ref
      .read(nostrNotifierProvider.notifier)
      .requestEvents(requestMessage, actionSource: const ActionSourceCurrentUserChat());

  final currentUserSigner = await ref.read(currentUserNostrEventSignerProvider.future);
  if (currentUserSigner == null) return;

  final dbProvider = ref.read(dBConversationsNotifierProvider.notifier);

  await for (final event in nostrEvents) {
    if (event.kind == 1059) {
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
  }

  // TODO: delete it when create conversation is implemented
  // const receiverPubkey = 'c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377';

  // final initMessage = await PrivateDirectMessageData.fromRawContent('')
  //     .toEventMessage(pubkey: receiverPubkey);

  // final message = await PrivateDirectMessageData.fromRawContent('test-message-content')
  //     .toEventMessage(pubkey: receiverPubkey);

  // await dbProvider.insertEventMessage(initMessage);
  // await dbProvider.insertEventMessage(message);
}
