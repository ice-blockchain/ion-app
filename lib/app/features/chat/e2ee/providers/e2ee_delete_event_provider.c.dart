// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/conversation_to_delete.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/chat/providers/dao/conversation_dao_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/data/models/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
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
    forEveryone: forEveryone,
    messageEvents: messageEvents,
  );
}

@riverpod
class E2eeDeleteMessageNotifier extends _$E2eeDeleteMessageNotifier {
  @override
  FutureOr<void> build({required EventMessage eventMessage}) {}

  Future<void> deleteMessage({
    bool forEveryone = false,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        await _deleteMessages(
          ref: ref,
          messageEvents: [eventMessage],
          forEveryone: forEveryone,
        );
      },
    );
  }
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
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  final conversationPubkeysNotifier = ref.watch(conversationPubkeysProvider.notifier);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final deleteRequest = DeletionRequest(
    events: [
      EventToDelete(
        eventReference: ImmutableEventReference(
          eventId: reactionEvent.id,
          pubkey: reactionEvent.masterPubkey,
          kind: PrivateMessageReactionEntity.kind,
        ),
      ),
    ],
  );

  final eventMessage = await deleteRequest.toEventMessage(
    NoPrivateSigner(eventSigner.publicKey),
    masterPubkey: currentUserMasterPubkey,
  );

  await Future.wait(
    participantsMasterPubkeys.map((masterPubkey) async {
      final participantsKeysMap =
          await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

      final pubkeys = participantsKeysMap[masterPubkey];

      if (pubkeys == null) {
        throw UserPubkeyNotFoundException(masterPubkey);
      }
      for (final pubkey in pubkeys) {
        await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
              eventSigner: eventSigner,
              masterPubkey: masterPubkey,
              eventMessage: eventMessage,
              wrappedKinds: [DeletionRequestEntity.kind.toString()],
              pubkey: pubkey,
            );
      }
    }),
  );
}

Future<void> _deleteMessages({
  required Ref ref,
  required bool forEveryone,
  required List<EventMessage> messageEvents,
}) async {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  final conversationPubkeysNotifier = ref.watch(conversationPubkeysProvider.notifier);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final participantsMasterPubkeys =
      forEveryone ? messageEvents.first.participantsMasterPubkeys : [currentUserMasterPubkey];

  final deleteRequest = DeletionRequest(
    events: messageEvents
        .map((event) {
          final entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(event);

          if (entity.data.quotedEvent != null) {
            return [
              EventToDelete(
                eventReference: entity.data.quotedEvent!.eventReference
                    .copyWith(kind: GenericRepostEntity.kind),
              ),
              EventToDelete(eventReference: entity.toEventReference()),
            ];
          }

          return [EventToDelete(eventReference: entity.toEventReference())];
        })
        .expand((element) => element)
        .toList(),
  );

  final eventMessage = await deleteRequest.toEventMessage(
    NoPrivateSigner(eventSigner.publicKey),
    masterPubkey: currentUserMasterPubkey,
  );

  await Future.wait(
    participantsMasterPubkeys.map((masterPubkey) async {
      final participantsKeysMap =
          await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

      final pubkeys = participantsKeysMap[masterPubkey];

      if (pubkeys == null) {
        throw UserPubkeyNotFoundException(masterPubkey);
      }

      for (final pubkey in pubkeys) {
        await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
              eventSigner: eventSigner,
              masterPubkey: masterPubkey,
              eventMessage: eventMessage,
              wrappedKinds: [DeletionRequestEntity.kind.toString()],
              pubkey: pubkey,
            );
      }
    }),
  );
}

Future<void> _deleteConversations({
  required Ref ref,
  required bool forEveryone,
  required List<String> conversationIds,
}) async {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  final conversationPubkeysNotifier = ref.watch(conversationPubkeysProvider.notifier);

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  final deleteRequest =
      DeletionRequest(events: conversationIds.map(ConversationToDelete.new).toList());

  final eventMessage = await deleteRequest.toEventMessage(
    NoPrivateSigner(eventSigner.publicKey),
    masterPubkey: currentUserMasterPubkey,
  );

  await Future.wait(
    conversationIds.map(
      (conversationId) async {
        final participantsMasterPubkeys = forEveryone
            ? await ref.read(conversationDaoProvider).getConversationParticipants(conversationId)
            : [currentUserMasterPubkey];

        return Future.wait(
          participantsMasterPubkeys.map((masterPubkey) async {
            final participantsKeysMap =
                await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

            final pubkeys = participantsKeysMap[masterPubkey];

            if (pubkeys == null) {
              throw UserPubkeyNotFoundException(masterPubkey);
            }

            for (final pubkey in pubkeys) {
              await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
                    eventSigner: eventSigner,
                    masterPubkey: masterPubkey,
                    eventMessage: eventMessage,
                    wrappedKinds: [DeletionRequestEntity.kind.toString()],
                    pubkey: pubkey,
                  );
            }
          }),
        );
      },
    ),
  );
}
