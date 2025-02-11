// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_message_count_provider.c.g.dart';

@riverpod
Stream<int> getUnreadMessagesCount(Ref ref, String conversationId) {
  return ref.watch(conversationMessageDaoProvider).getUnreadMessagesCount(conversationId);
}
