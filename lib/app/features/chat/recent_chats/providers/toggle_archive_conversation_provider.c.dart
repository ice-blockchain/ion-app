// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifier_tag.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toggle_archive_conversation_provider.c.g.dart';

@riverpod
class ToggleArchivedConversations extends _$ToggleArchivedConversations {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> toogleConversation(List<ConversationListItem> conversations) async {
    final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final bookmarkSet = await _getInitialBookmarkSet();
    final updatedBookmarkSet = await _processConversations(conversations, bookmarkSet);

    await _updateBookmarks(updatedBookmarkSet, currentUserPubkey);
  }

  Future<BookmarksSetData> _getInitialBookmarkSet() async {
    final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);
    final archivedConversationBookmarksSet = bookmarksMap[BookmarksSetType.chats];

    return archivedConversationBookmarksSet?.data ??
        const BookmarksSetData(
          type: BookmarksSetType.chats,
          postsRefs: [],
          articlesRefs: [],
        );
  }

  Future<List<List<String>>?> _decryptContent(String content) async {
    if (content.isEmpty) return null;

    final e2eeService = await ref.read(encryptedMessageServiceProvider.future);
    final decryptedContent = await e2eeService.decryptMessage(content);

    if (decryptedContent.isEmpty) return null;

    return (jsonDecode(decryptedContent) as List)
        .map((e) => (e as List).map((s) => s.toString()).toList())
        .toList();
  }

  Future<BookmarksSetData> _processCommunityConversation(
    ConversationListItem conversation,
    BookmarksSetData bookmarkSet,
  ) async {
    final isArchived = bookmarkSet.communitiesIds.contains(conversation.conversationId);
    await ref
        .read(conversationDaoProvider)
        .setArchived(conversation.conversationId, isArchived: !isArchived);

    if (isArchived) {
      return bookmarkSet.copyWith(
        communitiesIds:
            bookmarkSet.communitiesIds.where((id) => id != conversation.conversationId).toList(),
      );
    } else {
      return bookmarkSet.copyWith(
        communitiesIds: [...bookmarkSet.communitiesIds, conversation.conversationId],
      );
    }
  }

  Future<BookmarksSetData> _processPrivateConversation(
    ConversationListItem conversation,
    BookmarksSetData bookmarkSet,
    List<List<String>>? parsedContent,
  ) async {
    final encryptedGroupIds = CommunityIdentifierTag(value: conversation.conversationId).toTag();
    List<List<String>> updatedContent;

    if (parsedContent == null) {
      await ref.read(conversationDaoProvider).setArchived(conversation.conversationId);
      updatedContent = [encryptedGroupIds];
    } else {
      final existItem = parsedContent
          .firstWhereOrNull((element) => element.toString() == encryptedGroupIds.toString());

      if (existItem == null) {
        await ref.read(conversationDaoProvider).setArchived(conversation.conversationId);
        updatedContent = [...parsedContent, encryptedGroupIds];
      } else {
        await ref
            .read(conversationDaoProvider)
            .setArchived(conversation.conversationId, isArchived: false);
        updatedContent = parsedContent..remove(existItem);
      }
    }

    final encryptedMessageService = await ref.read(encryptedMessageServiceProvider.future);
    final encodedContent = updatedContent.isEmpty ? '' : jsonEncode(updatedContent);
    final encryptedContent = encodedContent.isNotEmpty
        ? await encryptedMessageService.encryptMessage(encodedContent)
        : encodedContent;

    return bookmarkSet.copyWith(content: encryptedContent);
  }

  Future<BookmarksSetData> _processConversations(
    List<ConversationListItem> conversations,
    BookmarksSetData bookmarkSet,
  ) async {
    var updatedBookmarkSet = bookmarkSet;
    final parsedContent = await _decryptContent(bookmarkSet.content);

    for (final conversation in conversations) {
      if (conversation.type == ConversationType.community) {
        updatedBookmarkSet = await _processCommunityConversation(conversation, updatedBookmarkSet);
      } else {
        updatedBookmarkSet =
            await _processPrivateConversation(conversation, updatedBookmarkSet, parsedContent);
      }
    }

    return updatedBookmarkSet;
  }

  Future<void> _updateBookmarks(BookmarksSetData bookmarkSet, String masterPubkey) async {
    await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
          bookmarkSet..toReplaceableEventReference(masterPubkey),
        );
  }
}
