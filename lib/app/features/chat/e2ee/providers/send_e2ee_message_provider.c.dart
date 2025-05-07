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
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_message_provider.c.g.dart';

@riverpod
Future<SendE2eeMessageService> sendE2eeMessageService(Ref ref) async {
  final sendE2eeChatMessageService = ref.read(sendE2eeChatMessageServiceProvider);
  final sealService = await ref.watch(ionConnectSealServiceProvider.future);
  final wrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  return SendE2eeMessageService(
    eventSigner: eventSigner,
    sealService: sealService,
    wrapService: wrapService,
    env: ref.watch(envProvider.notifier),
    sendE2eeChatMessageService: sendE2eeChatMessageService,
    ionConnectNotifier: ref.watch(ionConnectNotifierProvider.notifier),
    currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider) ?? '',
    conversationPubkeysNotifier: ref.watch(conversationPubkeysProvider.notifier),
  );
}

class SendE2eeMessageService {
  SendE2eeMessageService({
    required this.env,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.ionConnectNotifier,
    required this.currentUserMasterPubkey,
    required this.sendE2eeChatMessageService,
    required this.conversationPubkeysNotifier,
  });

  final Env env;
  final EventSigner? eventSigner;
  final String currentUserMasterPubkey;
  final IonConnectSealService sealService;
  final IonConnectNotifier ionConnectNotifier;
  final IonConnectGiftWrapService wrapService;
  final ConversationPubkeys conversationPubkeysNotifier;
  final SendE2eeChatMessageService sendE2eeChatMessageService;

  final allowedStatus = [MessageDeliveryStatus.received, MessageDeliveryStatus.read];

  // TODO: Create a separate provider for message status updates
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

        for (final pubkey in pubkeys) {
          await sendE2eeChatMessageService.sendWrappedMessage(
            pubkey: pubkey,
            eventSigner: eventSigner!,
            masterPubkey: masterPubkey,
            wrappedKinds: [PrivateMessageReactionEntity.kind.toString()],
            eventMessage:
                await messageReactionData.toEventMessage(NoPrivateSigner(eventSigner!.publicKey)),
          );
        }
      }),
    );
  }

  // TODO: Create a separate provider for reaction events
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

        for (final pubkey in pubkeys) {
          await sendE2eeChatMessageService.sendWrappedMessage(
            pubkey: pubkey,
            eventSigner: eventSigner!,
            masterPubkey: masterPubkey,
            eventMessage: messageReactionEventMessage,
            wrappedKinds: [PrivateMessageReactionEntity.kind.toString()],
          );
        }
      }),
    );
  }
}
