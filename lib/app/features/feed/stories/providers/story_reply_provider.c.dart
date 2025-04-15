// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
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
      ['h', conversationId],
      ['k', ModifiablePostEntity.kind.toString()],
      ['b', currentUserMasterPubkey],
      ReplaceableEventReference(
        pubkey: story.pubkey,
        kind: ModifiablePostEntity.kind,
        dTag: story.data.replaceableEventId.value,
      ).toTag(),
    ];

    final id = EventMessage.calculateEventId(
      tags: tags,
      content: storyAsContent,
      kind: GenericRepostEntity.kind,
      publicKey: eventSigner.publicKey,
      createdAt: DateTime.now(),
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

    await ref.read(conversationPubkeysProvider.notifier).fetchUsersKeys(participantsMasterPubkeys);

    for (final masterPubkey in participantsMasterPubkeys) {
      final pubkey = ref.read(userMetadataProvider(masterPubkey)).valueOrNull?.pubkey;

      if (pubkey == null) {
        throw UserPubkeyNotFoundException(masterPubkey);
      }

      await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
        pubkey: pubkey,
        eventSigner: eventSigner,
        masterPubkey: masterPubkey,
        eventMessage: kind16Rumor,
        kinds: [
          GenericRepostEntity.kind.toString(),
          ModifiablePostEntity.kind.toString(),
        ],
      );
    }

    final sentKind14EventMessage = await ref.read(sendE2eeChatMessageServiceProvider).sendMessage(
      content: replyText ?? '',
      conversationId: conversationId,
      participantsMasterPubkeys: participantsMasterPubkeys,
      referencePostTag: QuotedImmutableEvent(
        eventReference:
            ImmutableEventReference(eventId: kind16Rumor.id, pubkey: kind16Rumor.pubkey),
      ).toTag(),
      mediaFiles: [],
    );

    if (replyEmoji != null) {
      await (await ref.read(sendE2eeMessageServiceProvider.future)).sendReaction(
        content: replyEmoji,
        kind14Rumor: sentKind14EventMessage,
      );
    }

    state = const AsyncData(null);
  }
}
