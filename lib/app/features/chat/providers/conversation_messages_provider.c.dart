// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_messages_provider.c.g.dart';

@riverpod
class ConversationMessages extends _$ConversationMessages {
  @override
  Stream<Map<DateTime, List<EventMessage>>> build(String conversationId) {
    return ref.watch(conversationTableDaoProvider).getMessages(conversationId);
  }
}
