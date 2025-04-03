// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/conversation_to_delete.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_delete_event_provider.c.g.dart';

@riverpod
Future<void> e2eeDeleteReaction(
  Ref ref, {
  required EventMessage reactionEvent,
  required List<String> participantsMasterPubkeys,
}) async {
  await _deleteReaction(
    ref: ref,
    reactionEvent: reactionEvent,
    participantsMasterPubkeys: participantsMasterPubkeys,
  );
}

@riverpod
Future<void> e2eeDeleteMessage(
  Ref ref, {
  required List<EventMessage> messageEvents,
  bool forEveryone = false,
}) async {
  await _deleteMessages(
    ref: ref,
    messageEvents: messageEvents,
    forEveryone: forEveryone,
  );
}

@riverpod
Future<void> e2eeDeleteConversation(
  Ref ref, {
  required List<String> conversationIds,
  bool forEveryone = false,
}) async {
  await _deleteConversations(
    ref: ref,
    forEveryone: forEveryone,
    conversationIds: conversationIds,
  );
}

Future<void> _deleteReaction({
  required Ref ref,
  required EventMessage reactionEvent,
  required List<String> participantsMasterPubkeys,
}) async {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  final signer = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
  final conversationPubkeysNotifier = ref.watch(conversationPubkeysProvider.notifier);

  if (signer == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  if (reactionEvent.pubkey != signer.publicKey) {
    throw PubkeysDoNotMatchException();
  }

  final deleteRequest = DeletionRequest(
    events: [EventToDelete(eventId: reactionEvent.id, kind: reactionEvent.kind)],
  );

  final eventMessage = await deleteRequest.toEventMessage(signer);

  await Future.wait(
    participantsMasterPubkeys.map((masterPubkey) async {
      final currentUser = currentUserMasterPubkey == masterPubkey;

      final participantsKeysMap =
          await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

      final pubkey = participantsKeysMap[masterPubkey];

      if (pubkey == null) {
        throw UserPubkeyNotFoundException(masterPubkey);
      }
      final giftWrap = await _createGiftWrap(
        ref: ref,
        signer: signer,
        eventMessage: eventMessage,
        receiverMasterPubkey: masterPubkey,
        receiverPubkey: currentUser ? signer.publicKey : pubkey,
      );

      await ionConnectNotifier.sendEvent(
        giftWrap,
        cache: false,
        actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
      );
    }),
  );
}

Future<void> _deleteMessages({
  required Ref ref,
  required List<EventMessage> messageEvents,
  required bool forEveryone,
}) async {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  final signer = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
  final conversationPubkeysNotifier = ref.watch(conversationPubkeysProvider.notifier);

  if (signer == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  if (messageEvents.any((event) => event.pubkey != signer.publicKey)) {
    throw PubkeysDoNotMatchException();
  }

  final participantsMasterPubkeys = forEveryone
      ? PrivateDirectMessageEntity.fromEventMessage(messageEvents.first).allPubkeys
      : [currentUserMasterPubkey];

  final deleteRequest = DeletionRequest(
    events:
        messageEvents.map((event) => EventToDelete(eventId: event.id, kind: event.kind)).toList(),
  );

  final eventMessage = await deleteRequest.toEventMessage(signer);

  await Future.wait(
    participantsMasterPubkeys.map((masterPubkey) async {
      final currentUser = currentUserMasterPubkey == masterPubkey;

      final participantsKeysMap =
          await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

      final pubkey = participantsKeysMap[masterPubkey];

      if (pubkey == null) {
        throw UserPubkeyNotFoundException(masterPubkey);
      }
      final giftWrap = await _createGiftWrap(
        ref: ref,
        signer: signer,
        eventMessage: eventMessage,
        receiverMasterPubkey: masterPubkey,
        receiverPubkey: currentUser ? signer.publicKey : pubkey,
      );

      await ionConnectNotifier.sendEvent(
        giftWrap,
        cache: false,
        actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
      );
    }),
  );
}

Future<void> _deleteConversations({
  required Ref ref,
  required List<String> conversationIds,
  required bool forEveryone,
}) async {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  final signer = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  final ionConnectNotifier = ref.watch(ionConnectNotifierProvider.notifier);
  final conversationPubkeysNotifier = ref.watch(conversationPubkeysProvider.notifier);

  if (signer == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final deleteRequest = DeletionRequest(
    events: conversationIds.map(ConversationToDelete.new).toList(),
  );

  final eventMessage = await deleteRequest.toEventMessage(signer);

  await Future.wait(
    conversationIds.map(
      (conversationId) async {
        final participantsMasterPubkeys = forEveryone
            ? await ref.read(conversationDaoProvider).getConversationParticipants(conversationId)
            : [currentUserMasterPubkey];

        return Future.wait(
          participantsMasterPubkeys.map((masterPubkey) async {
            final currentUser = currentUserMasterPubkey == masterPubkey;

            final participantsKeysMap =
                await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

            final pubkey = participantsKeysMap[masterPubkey];

            if (pubkey == null) {
              throw UserPubkeyNotFoundException(masterPubkey);
            }
            final giftWrap = await _createGiftWrap(
              ref: ref,
              signer: signer,
              eventMessage: eventMessage,
              receiverMasterPubkey: masterPubkey,
              receiverPubkey: currentUser ? signer.publicKey : pubkey,
            );

            await ionConnectNotifier.sendEvent(
              giftWrap,
              cache: false,
              actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
            );
          }),
        );
      },
    ),
  );
}

Future<EventMessage> _createGiftWrap({
  required Ref ref,
  required String receiverPubkey,
  required String receiverMasterPubkey,
  required EventSigner signer,
  required EventMessage eventMessage,
}) async {
  final env = ref.read(envProvider.notifier);
  final sealService = await ref.read(ionConnectSealServiceProvider.future);
  final wrapService = await ref.read(ionConnectGiftWrapServiceProvider.future);

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
    expirationTag: expirationTag,
    receiverPubkey: receiverPubkey,
    contentKind: DeletionRequest.kind,
    receiverMasterPubkey: receiverMasterPubkey,
  );

  return wrap;
}
