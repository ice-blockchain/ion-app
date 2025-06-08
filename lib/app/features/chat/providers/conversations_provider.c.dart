// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/data/models/database/chat_database.c.dart';
import 'package:ion/app/features/chat/recent_chats/data/models/conversation_list_item.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@riverpod
Stream<List<ConversationListItem>> conversations(Ref ref) {
  return ref.watch(conversationDaoProvider).watch();
}

@riverpod
Future<List<ConversationListItem>> archivedConversations(
  Ref ref,
) {
  return ref.watch(conversationsProvider.selectAsync((t) => t.where((c) => c.isArchived).toList()));
}
