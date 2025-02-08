// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat-v2/database/chat_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_message_count_provider.c.g.dart';

@riverpod
class UnreadMessageCountProvider extends _$UnreadMessageCountProvider {
  @override
  Stream<int> build(String conversationUUID) {
    return ref.watch(chatMessageTableDaoProvider).getUnreadMessagesCount(conversationUUID);
  }
}
