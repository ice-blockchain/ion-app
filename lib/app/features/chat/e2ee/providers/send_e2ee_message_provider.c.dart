// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/pubkey_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
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
    required this.env,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.ionConnectNotifier,
    required this.conversationPubkeysNotifier,
    required this.currentUserMasterPubkey,
  });

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
    required Ref ref,
    required MessageDeliveryStatus status,
    required EventMessage messageEventMessage,
  }) async {
    if (!allowedStatus.contains(status)) {
      return;
    }

    final eventMessage = await createEventMessage(
      content: status.name,
      signer: eventSigner!,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ReplaceableEventReference(
          kind: messageEventMessage.kind,
          pubkey: messageEventMessage.pubkey,
          dTag: messageEventMessage.sharedId,
        ).toTag(),
        ['b', currentUserMasterPubkey],
      ],
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
          eventMessage: eventMessage,
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
    final eventMessage = await createEventMessage(
      content: content,
      signer: eventSigner!,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', ReplaceablePrivateDirectMessageEntity.kind.toString()],
        [PubkeyTag.tagName, kind14Rumor.pubkey],
        [RelatedImmutableEvent.tagName, kind14Rumor.id],
        ['b', currentUserMasterPubkey],
      ],
    );

    final privateDirectMessageEntity = PrivateDirectMessageData.fromEventMessage(kind14Rumor);

    final participantsMasterPubkeys =
        privateDirectMessageEntity.relatedPubkeys?.map((tag) => tag.value).toList();

    if (participantsMasterPubkeys == null) {
      throw ParticipantsMasterPubkeysNotFoundException(kind14Rumor.id);
    }

    await Future.wait(
      participantsMasterPubkeys.map((masterPubkey) async {
        final currentUser = currentUserMasterPubkey == masterPubkey;

        final participantsKeysMap =
            await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);
        final pubkey = participantsKeysMap[masterPubkey];

        if (pubkey == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        final giftWrap = await createGiftWrap(
          signer: eventSigner!,
          eventMessage: eventMessage,
          receiverMasterPubkey: masterPubkey,
          kinds: [PrivateMessageReactionEntity.kind.toString()],
          receiverPubkey: currentUser ? eventSigner!.publicKey : pubkey,
        );

        await ionConnectNotifier.sendEvent(
          giftWrap,
          cache: false,
          actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
        );
      }),
    );
  }

  Future<EventMessage> createEventMessage({
    required String content,
    required EventSigner signer,
    required List<List<String>> tags,
    String? previousId,
    int kind = ReplaceablePrivateDirectMessageEntity.kind,
  }) async {
    final createdAt = DateTime.now().toUtc();

    final id = previousId ??
        EventMessage.calculateEventId(
          tags: tags,
          kind: kind,
          content: content,
          createdAt: createdAt,
          publicKey: signer.publicKey,
        );

    final eventMessage = EventMessage(
      id: id,
      tags: tags,
      kind: kind,
      content: content,
      createdAt: createdAt,
      pubkey: signer.publicKey,
      sig: null,
    );

    return eventMessage;
  }

  Future<EventMessage> createGiftWrap({
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required EventSigner signer,
    required EventMessage eventMessage,
    List<String>? kinds,
  }) async {
    final contentKinds = kinds ?? [ReplaceablePrivateDirectMessageEntity.kind.toString()];

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        Duration(hours: env.get<int>(EnvVariable.GIFT_WRAP_EXPIRATION_HOURS)),
      ),
    ).toTag();

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    final wrap = await wrapService.createWrap(
      event: seal,
      contentKinds: contentKinds,
      receiverPubkey: receiverPubkey,
      receiverMasterPubkey: receiverMasterPubkey,
      expirationTag: expirationTag,
    );

    return wrap;
  }
}
