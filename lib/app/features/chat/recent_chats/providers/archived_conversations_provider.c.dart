// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/data/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/database/chat_database.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/services/providers/ion_connect/encrypted_message_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archived_conversations_provider.c.g.dart';

@riverpod
Future<List<String>> archivedConversations(Ref ref) async {
  final archivedConversationBookmarksSetData =
      await ref.watch(currentUserChatBookmarksDataProvider.future) ??
          const BookmarksSetData(
            type: BookmarksSetType.chats,
            postsRefs: [],
            articlesRefs: [],
          );

  final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
  final encryptedMessageService = await ref.watch(encryptedMessageServiceProvider.future);

  if (currentUserPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final content = archivedConversationBookmarksSetData.content;

  final decryptedContent = content.isNotEmpty
      ? await encryptedMessageService.decryptMessage(
          archivedConversationBookmarksSetData.content,
        )
      : archivedConversationBookmarksSetData.content;

  final encryptedConversationCommunityIds = decryptedContent.isNotEmpty
      ? (jsonDecode(decryptedContent) as List<dynamic>)
          .map(
            (e) => ConversationIdentifier.fromTag(
              (e as List<dynamic>).map((s) => s.toString()).toList(),
            ).value,
          )
          .toList()
      : null;

  final archivedConversations = [
    ...archivedConversationBookmarksSetData.communitiesIds,
    if (encryptedConversationCommunityIds != null) ...encryptedConversationCommunityIds,
  ];

  await ref.watch(conversationDaoProvider).updateArchivedConversations(archivedConversations);

  return archivedConversations;
}
