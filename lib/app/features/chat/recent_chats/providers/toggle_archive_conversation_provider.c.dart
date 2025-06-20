// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
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

  Future<void> toggleConversations(List<ConversationListItem> conversations) async {
    final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final bookmarkSet = await _getInitialBookmarkSet();

    final updatedBookmarkSet = await _processConversations(
      initialBookmarkSet: bookmarkSet,
      conversations: conversations,
    );

    await _updateBookmarks(
      bookmarkSet: updatedBookmarkSet,
      masterPubkey: currentUserPubkey,
    );
  }

  Future<BookmarksSetData> _getInitialBookmarkSet() async {
    final archivedConversationBookmarksData =
        await ref.read(currentUserChatBookmarksDataProvider.future);
    return archivedConversationBookmarksData ??
        BookmarksSetData(
          eventReferences: [],
          type: BookmarksSetType.chats.dTagName,
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

  Future<BookmarksSetData> _processConversations({
    required BookmarksSetData initialBookmarkSet,
    required List<ConversationListItem> conversations,
  }) async {
    var updatedBookmarkSet = initialBookmarkSet;

    final e2eeConversations = conversations
        .where((conversation) => conversation.type == ConversationType.oneToOne)
        .toList();

    final communityConversations = conversations
        .where((conversation) => conversation.type == ConversationType.community)
        .toList();

    if (e2eeConversations.isNotEmpty) {
      updatedBookmarkSet = await _generateE2eeBookmarkSet(
        initialBookmarkSet: initialBookmarkSet,
        conversations: e2eeConversations,
      );
    }

    if (communityConversations.isNotEmpty) {
      updatedBookmarkSet = await _generateCommunityConversationSet(
        initialBookmarkSet: updatedBookmarkSet,
        conversations: communityConversations,
      );
    }

    return updatedBookmarkSet;
  }

  Future<BookmarksSetData> _generateCommunityConversationSet({
    required BookmarksSetData initialBookmarkSet,
    required List<ConversationListItem> conversations,
  }) async {
    final conversationsIds =
        conversations.map((conversation) => conversation.conversationId).toList();

    for (final conversation in conversations) {
      final isAlreadyArchived =
          initialBookmarkSet.communitiesIds.contains(conversation.conversationId);

      await ref
          .read(conversationDaoProvider)
          .setArchived(conversationsIds, isArchived: !isAlreadyArchived);

      if (isAlreadyArchived) {
        return initialBookmarkSet.copyWith(
          communitiesIds: initialBookmarkSet.communitiesIds
              .where((id) => id != conversation.conversationId)
              .toList(),
        );
      } else {
        return initialBookmarkSet.copyWith(
          communitiesIds: [...initialBookmarkSet.communitiesIds, conversation.conversationId],
        );
      }
    }

    return initialBookmarkSet;
  }

  Future<BookmarksSetData> _generateE2eeBookmarkSet({
    required BookmarksSetData initialBookmarkSet,
    required List<ConversationListItem> conversations,
  }) async {
    var updatedTags = <List<String>>[];

    final decryptedTags = await _decryptContent(initialBookmarkSet.content);
    final conversationIds = conversations.map((e) => e.conversationId).toList();
    final allConversationTags = conversations
        .map((conversation) => ConversationIdentifier(value: conversation.conversationId).toTag())
        .toList();

    if (decryptedTags == null) {
      await ref.read(conversationDaoProvider).setArchived(conversationIds);
      updatedTags = allConversationTags;
    } else {
      for (final conversation in conversations) {
        final conversationTag = ConversationIdentifier(value: conversation.conversationId).toTag();

        final archivedConversationTag = decryptedTags.firstWhereOrNull(
          (tag) => tag.equals(conversationTag),
        );

        if (archivedConversationTag == null) {
          await ref.read(conversationDaoProvider).setArchived([conversation.conversationId]);
          updatedTags = [...decryptedTags, conversationTag];
        } else {
          await ref
              .read(conversationDaoProvider)
              .setArchived([conversation.conversationId], isArchived: false);

          updatedTags = decryptedTags..remove(archivedConversationTag);
        }
      }
    }

    final encryptedMessageService = await ref.read(encryptedMessageServiceProvider.future);
    final encodedContent = updatedTags.isEmpty ? '' : jsonEncode(updatedTags);
    final encryptedContent = encodedContent.isNotEmpty
        ? await encryptedMessageService.encryptMessage(encodedContent)
        : encodedContent;

    return initialBookmarkSet.copyWith(content: encryptedContent);
  }

  Future<void> _updateBookmarks({
    required String masterPubkey,
    required BookmarksSetData bookmarkSet,
  }) async {
    await ref
        .read(ionConnectNotifierProvider.notifier)
        .sendEntityData(bookmarkSet..toReplaceableEventReference(masterPubkey));

    return;
  }
}
