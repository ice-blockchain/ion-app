// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/database/chat_database.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_reaction_provider.c.g.dart';

@riverpod
Future<SendE2eeReactionService> sendE2eeReactionService(Ref ref) async {
  final sendE2eeChatMessageService = ref.read(sendE2eeChatMessageServiceProvider);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  return SendE2eeReactionService(
    eventSigner: eventSigner,
    sendE2eeChatMessageService: sendE2eeChatMessageService,
    currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider) ?? '',
    conversationPubkeysNotifier: ref.watch(conversationPubkeysProvider.notifier),
  );
}

class SendE2eeReactionService {
  SendE2eeReactionService({
    required this.eventSigner,
    required this.currentUserMasterPubkey,
    required this.sendE2eeChatMessageService,
    required this.conversationPubkeysNotifier,
  });

  final EventSigner? eventSigner;
  final String currentUserMasterPubkey;
  final SendE2eeChatMessageService sendE2eeChatMessageService;
  final ConversationPubkeys conversationPubkeysNotifier;

  final allowedStatus = [MessageDeliveryStatus.received, MessageDeliveryStatus.read];

  Future<void> sendReaction({
    required String content,
    required EventMessage kind14Rumor,
  }) async {
    final kind14Event = ReplaceablePrivateDirectMessageEntity.fromEventMessage(kind14Rumor);
    final messageReactionEventMessage = await PrivateMessageReactionEntityData(
      content: content,
      masterPubkey: currentUserMasterPubkey,
      reference: kind14Event.toEventReference(),
    ).toEventMessage(NoPrivateSigner(eventSigner!.publicKey));

    final privateDirectMessageEntity =
        ReplaceablePrivateDirectMessageData.fromEventMessage(kind14Rumor);

    final participantsMasterPubkeys =
        privateDirectMessageEntity.relatedPubkeys?.map((tag) => tag.value).toList();

    if (participantsMasterPubkeys == null) {
      throw ParticipantsMasterPubkeysNotFoundException(kind14Rumor.id);
    }

    await Future.wait(
      participantsMasterPubkeys.map((masterPubkey) async {
        final participantsKeysMap =
            await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);
        final pubkeys = participantsKeysMap[masterPubkey];

        if (pubkeys == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        await Future.wait(
          pubkeys.map((pubkey) async {
            await sendE2eeChatMessageService.sendWrappedMessage(
              pubkey: pubkey,
              eventSigner: eventSigner!,
              masterPubkey: masterPubkey,
              eventMessage: messageReactionEventMessage,
              wrappedKinds: [
                // Using doubled kind 7 to differentiate between reactions and statuses
                PrivateMessageReactionEntity.kind.toString(),
                PrivateMessageReactionEntity.kind.toString(),
              ],
            );
          }),
        );
      }),
    );
  }
}
