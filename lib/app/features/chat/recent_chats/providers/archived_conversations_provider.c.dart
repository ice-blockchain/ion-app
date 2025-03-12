// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifier_tag.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archived_conversations_provider.c.g.dart';

@riverpod
Future<List<String>> archivedConversations(Ref ref) async {
  final archivedConversationBookmarksSet = ref.watch(currentUserBookmarksProvider).valueOrNull;

  if (archivedConversationBookmarksSet == null) {
    return [];
  }

  final archivedConversationBookmarksSetData =
      archivedConversationBookmarksSet[BookmarksSetType.chats]?.data ??
          const BookmarksSetData(
            type: BookmarksSetType.chats,
            postsRefs: [],
            articlesRefs: [],
          );

  final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
  final encryptedMessageService = await ref.read(encryptedMessageServiceProvider.future);

  if (currentUserPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final content = archivedConversationBookmarksSetData.content;

  final decryptedContent = content.isNotEmpty
      ? await encryptedMessageService.decryptMessage(
          archivedConversationBookmarksSetData.content,
        )
      : archivedConversationBookmarksSetData.content;

  final encrpytedConversationCommunityIds = decryptedContent.isNotEmpty
      ? (jsonDecode(decryptedContent) as List<dynamic>)
          .map(
            (e) => CommunityIdentifierTag.fromTag(
              (e as List<dynamic>).map((s) => s.toString()).toList(),
            ).value,
          )
          .toList()
      : null;

  final archivedConversations = [
    ...archivedConversationBookmarksSetData.communitiesIds,
    if (encrpytedConversationCommunityIds != null) ...encrpytedConversationCommunityIds,
  ];

  await ref.watch(conversationDaoProvider).updateArchivedConversations(archivedConversations);

  return archivedConversations;
}
