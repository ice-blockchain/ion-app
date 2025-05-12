// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_message_status_provider.c.g.dart';

@riverpod
Future<SendE2eeMessageStatusService> sendE2eeMessageStatusService(Ref ref) async {
  final sendE2eeChatMessageService = ref.read(sendE2eeChatMessageServiceProvider);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  return SendE2eeMessageStatusService(
    eventSigner: eventSigner,
    sendE2eeChatMessageService: sendE2eeChatMessageService,
    currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider) ?? '',
    conversationPubkeysNotifier: ref.watch(conversationPubkeysProvider.notifier),
  );
}

class SendE2eeMessageStatusService {
  SendE2eeMessageStatusService({
    required this.eventSigner,
    required this.sendE2eeChatMessageService,
    required this.currentUserMasterPubkey,
    required this.conversationPubkeysNotifier,
  });

  final EventSigner? eventSigner;
  final SendE2eeChatMessageService sendE2eeChatMessageService;
  final String currentUserMasterPubkey;
  final ConversationPubkeys conversationPubkeysNotifier;

  final allowedStatus = [MessageDeliveryStatus.received, MessageDeliveryStatus.read];

  Future<void> sendMessageStatus({
    required MessageDeliveryStatus status,
    required EventMessage messageEventMessage,
  }) async {
    if (!allowedStatus.contains(status)) {
      return;
    }

    final eventReference =
        ReplaceablePrivateDirectMessageEntity.fromEventMessage(messageEventMessage)
            .toEventReference();

    final messageReactionData = PrivateMessageReactionEntityData(
      content: status.name,
      reference: eventReference,
      masterPubkey: currentUserMasterPubkey,
    );

    await Future.wait(
      messageEventMessage.participantsMasterPubkeys.map((masterPubkey) async {
        final participantsKeysMap = await conversationPubkeysNotifier
            .fetchUsersKeys(messageEventMessage.participantsMasterPubkeys);

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
              wrappedKinds: [PrivateMessageReactionEntity.kind.toString()],
              eventMessage:
                  await messageReactionData.toEventMessage(NoPrivateSigner(eventSigner!.publicKey)),
            );
          }),
        );
      }),
    );
  }
}
