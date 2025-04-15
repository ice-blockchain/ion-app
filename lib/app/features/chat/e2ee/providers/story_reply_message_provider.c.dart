// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_reply_message_provider.c.g.dart';

@riverpod
class StoryReplyMessage extends _$StoryReplyMessage {
  @override
  Future<ModifiablePostEntity> build(String id) async {
    final kind16EventMessage = await ref.watch(eventMessageDaoProvider).getById(id);
    final storyEventMessage = EventMessage.fromPayloadJson(
      jsonDecode(kind16EventMessage.content) as Map<String, dynamic>,
    );

    final story = ModifiablePostEntity.fromEventMessage(storyEventMessage);

    return story;
  }
}
