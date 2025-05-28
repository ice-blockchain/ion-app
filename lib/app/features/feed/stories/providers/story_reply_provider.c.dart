// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_reaction_provider.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_reply_provider.c.g.dart';

@riverpod
class StoryReply extends _$StoryReply {
  @override
  FutureOr<void> build() {}

  Future<void> sendReply(
    ModifiablePostEntity story, {
    String? replyText,
    String? replyEmoji,
  }) async {
    state = await AsyncValue.guard(() async {
      state = const AsyncLoading();
      final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }

      final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

      if (currentUserMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final sendChatMessageService = ref.read(sendE2eeChatMessageServiceProvider);

      final existingConversationId =
          await ref.read(existChatConversationIdProvider(story.masterPubkey).future);

      final conversationId = existingConversationId ??
          sendChatMessageService.generateConversationId(
            receiverPubkey: story.masterPubkey,
          );

      final storyEventMessage = await story.toEventMessage(story.data);
      final storyAsContent = jsonEncode(storyEventMessage.toJson().last);

      final tags = [
        MasterPubkeyTag(value: currentUserMasterPubkey).toTag(),
        ['k', ModifiablePostEntity.kind.toString()],
        [RelatedPubkey.tagName, eventSigner.publicKey],
        [ConversationIdentifier.tagName, conversationId],
        story.toEventReference().toTag(),
      ];

      final id = EventMessage.calculateEventId(
        tags: tags,
        content: storyAsContent,
        kind: GenericRepostEntity.kind,
        publicKey: eventSigner.publicKey,
        createdAt: DateTime.now().microsecondsSinceEpoch,
      );

      final kind16Rumor = EventMessage(
        id: id,
        tags: tags,
        content: storyAsContent,
        pubkey: eventSigner.publicKey,
        kind: GenericRepostEntity.kind,
        createdAt: storyEventMessage.createdAt,
        sig: null,
      );

      final participantsMasterPubkeys = [
        story.masterPubkey,
        currentUserMasterPubkey,
      ];

      final conversationPubkeysNotifier = ref.read(conversationPubkeysProvider.notifier);

      for (final masterPubkey in participantsMasterPubkeys) {
        final participantsKeysMap =
            await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);
        final pubkeys = participantsKeysMap[masterPubkey];

        if (pubkeys == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        for (final pubkey in pubkeys) {
          await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
            pubkey: pubkey,
            eventSigner: eventSigner,
            masterPubkey: masterPubkey,
            eventMessage: kind16Rumor,
            wrappedKinds: [
              GenericRepostEntity.kind.toString(),
              ModifiablePostEntity.kind.toString(),
            ],
          );
        }
      }

      final sentKind14EventMessage = await ref.read(sendE2eeChatMessageServiceProvider).sendMessage(
            content: replyText ?? '',
            conversationId: conversationId,
            participantsMasterPubkeys: participantsMasterPubkeys,
            quotedEvent: QuotedImmutableEvent(
              eventReference: ImmutableEventReference(
                eventId: kind16Rumor.id,
                pubkey: kind16Rumor.masterPubkey,
                kind: GenericRepostEntity.kind,
              ),
            ),
          );

      if (replyEmoji != null) {
        await (await ref.read(sendE2eeReactionServiceProvider.future)).sendReaction(
          content: replyEmoji,
          kind14Rumor: sentKind14EventMessage,
        );
      }
    });
  }
}
