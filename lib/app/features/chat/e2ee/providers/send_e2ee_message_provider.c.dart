// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_message_provider.c.g.dart';

@riverpod
Future<SendE2eeMessageService> sendE2eeMessageService(
  Ref ref,
) async {
  final sealService = await ref.watch(ionConnectSealServiceProvider.future);
  final wrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  return SendE2eeMessageService(
    ref: ref,
    eventSigner: eventSigner,
    sealService: sealService,
    wrapService: wrapService,
    env: ref.watch(envProvider.notifier),
    ionConnectNotifier: ref.watch(ionConnectNotifierProvider.notifier),
    conversationPubkeysNotifier: ref.watch(conversationPubkeysProvider.notifier),
    currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider) ?? '',
  );
}

class SendE2eeMessageService {
  SendE2eeMessageService({
    required this.ref,
    required this.env,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.ionConnectNotifier,
    required this.conversationPubkeysNotifier,
    required this.currentUserMasterPubkey,
  });

  final Ref ref;
  final Env env;
  final EventSigner? eventSigner;
  final IonConnectNotifier ionConnectNotifier;
  final IonConnectSealService sealService;
  final IonConnectGiftWrapService wrapService;
  final ConversationPubkeys conversationPubkeysNotifier;
  final String currentUserMasterPubkey;

  final allowedStatus = [MessageDeliveryStatus.received, MessageDeliveryStatus.read];

  // TODO: Create a separate provider for message status updates
  Future<void> sendMessageStatus({
    required MessageDeliveryStatus status,
    required EventMessage messageEventMessage,
  }) async {
    if (!allowedStatus.contains(status)) {
      return;
    }

    final messageReactionData = PrivateMessageReactionEntityData(
      content: status.name,
      reference: ReplaceableEventReference(
        kind: messageEventMessage.kind,
        pubkey: messageEventMessage.masterPubkey,
        dTag: messageEventMessage.sharedId,
      ),
      masterPubkey: currentUserMasterPubkey,
    );

    await Future.wait(
      messageEventMessage.participantsMasterPubkeys.map((masterPubkey) async {
        final participantsKeysMap = await conversationPubkeysNotifier
            .fetchUsersKeys(messageEventMessage.participantsMasterPubkeys);

        final pubkey = participantsKeysMap[masterPubkey];

        if (pubkey == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
          pubkey: pubkey,
          eventSigner: eventSigner!,
          eventMessage:
              await messageReactionData.toEventMessage(NoPrivateSigner(eventSigner!.publicKey)),
          masterPubkey: masterPubkey,
          wrappedKinds: [PrivateMessageReactionEntity.kind.toString()],
        );
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
      reference: kind14Event.toEventReference(),
      masterPubkey: currentUserMasterPubkey,
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
        final pubkey = participantsKeysMap[masterPubkey];

        if (pubkey == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
          eventSigner: eventSigner!,
          eventMessage: messageReactionEventMessage,
          masterPubkey: masterPubkey,
          pubkey: pubkey,
          wrappedKinds: [PrivateMessageReactionEntity.kind.toString()],
        );
      }),
    );
  }
}
