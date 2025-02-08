// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat-v2/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat-v2/database/chat_database.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toggle_archive_conversation_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ToggleArchivedConversations extends _$ToggleArchivedConversations {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> toogleConversation(List<ConversationListItem> conversations) async {
    final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);

    final archivedConversationBookmarksSet = bookmarksMap[BookmarksSetType.chats];

    var bookmarkSet = archivedConversationBookmarksSet?.data ??
        const BookmarksSetData(
          type: BookmarksSetType.chats,
          postsRefs: [],
          articlesRefs: [],
        );

    final currentUserPubkey = ref.read(currentPubkeySelectorProvider).valueOrNull;
    final e2eeService = await ref.read(ionConnectE2eeServiceProvider.future);

    if (currentUserPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final content = bookmarkSet.content;

    final decryptedContent = content.isNotEmpty
        ? await e2eeService.decryptMessage(
            bookmarkSet.content,
          )
        : bookmarkSet.content;

    var parsedContent = decryptedContent.isNotEmpty
        ? (jsonDecode(decryptedContent) as List)
            .map((e) => (e as List).map((s) => s.toString()).toList())
            .toList()
        : null;

    for (final conversation in conversations) {
      if (conversation.type == ConversationType.community) {
        final isArchived = bookmarkSet.communitiesIds.contains(conversation.uuid);

        if (isArchived) {
          await ref
              .read(conversationTableDaoProvider)
              .markAsArchived(conversation.uuid, isArchived: false);
          bookmarkSet = bookmarkSet.copyWith(
            communitiesIds:
                bookmarkSet.communitiesIds.where((id) => id != conversation.uuid).toList(),
          );
        } else {
          await ref.read(conversationTableDaoProvider).markAsArchived(conversation.uuid);
          bookmarkSet = bookmarkSet.copyWith(
            communitiesIds: [
              ...bookmarkSet.communitiesIds,
              conversation.uuid,
            ],
          );
        }
      } else {
        final encryptedGroupIds = CommunityIdentifierTag(value: conversation.uuid).toTag();

        if (parsedContent == null) {
          await ref.read(conversationTableDaoProvider).markAsArchived(conversation.uuid);
          parsedContent = [
            encryptedGroupIds,
          ];
        } else {
          final existItem = parsedContent
              .firstWhereOrNull((element) => element.toString() == encryptedGroupIds.toString());
          if (existItem == null) {
            await ref.read(conversationTableDaoProvider).markAsArchived(conversation.uuid);
            parsedContent.add(encryptedGroupIds);
          } else {
            await ref
                .read(conversationTableDaoProvider)
                .markAsArchived(conversation.uuid, isArchived: false);
            parsedContent.remove(existItem);
          }
        }

        final encodedContent = parsedContent.isEmpty ? '' : jsonEncode(parsedContent);
        final encryptedContent = encodedContent.isNotEmpty
            ? await e2eeService.encryptMessage(encodedContent)
            : encodedContent;

        bookmarkSet = bookmarkSet.copyWith(
          content: encryptedContent,
        );
      }
    }

    await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
          bookmarkSet..toReplaceableEventReference(currentUserPubkey),
        );
  }
}
