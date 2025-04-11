// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:developer';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_reply_provider.c.g.dart';

@riverpod
class StoryReply extends _$StoryReply {
  @override
  FutureOr<void> build() {}

  Future<void> sendReplyReaction(ModifiablePostEntity story) async {
    state = const AsyncLoading();

    final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final storyEventMessage = await story.toEventMessage(story.data);
    final storyAsContent = jsonEncode(storyEventMessage.toJson().last);

    final tags = [
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

    log(kind16Rumor.toString());

    await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
      eventSigner: eventSigner,
      eventMessage: kind16Rumor,
      pubkey: eventSigner.publicKey,
      masterPubkey: currentUserMasterPubkey,
      kinds: [
        GenericRepostEntity.kind.toString(),
        ModifiablePostEntity.kind.toString(),
      ],
    );

    await Future<void>.delayed(const Duration(seconds: 2));
    state = const AsyncData(null);
  }

  void sendReplyMessage() {}
}
