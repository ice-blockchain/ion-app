// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.r.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_privacy_provider.r.g.dart';

@riverpod
Future<bool> canSendMessage(Ref ref, String masterPubkey, {bool cache = true}) async {
  // 1. Check if the current user is followed by the target user
  final isFollowed = isCurrentUserFollowed(ref, masterPubkey, cache: cache);
  if (isFollowed) return true;

  // 2. Fetch user privacy settings
  final userMetadata = await ref.watch(
    userMetadataProvider(masterPubkey, cache: cache).future,
  );
  final whoCanMessage = userMetadata?.data.whoCanMessageYou;

  // If privacy setting allows everyone or is unset, allow messaging
  if (whoCanMessage == null) return true;

  // 3. Check if a conversation already exists
  final conversationId = await ref.read(
    existChatConversationIdProvider(masterPubkey).future,
  );

  if (conversationId == null) return false;

  // 4. Check if the conversation was deleted by the other user
  final isDeleted = await ref.watch(conversationDaoProvider).checkAnotherUserDeletedConversation(
        masterPubkey: masterPubkey,
        conversationId: conversationId,
      );

  return !isDeleted;
}
