import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archived_conversations_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ToggleArchivedConversations extends _$ToggleArchivedConversations {
  @override
  List<String> build() {
    final bookmarsMap = ref.watch(currentUserBookmarksProvider).valueOrNull;

    if (bookmarsMap == null) {
      return [];
    }

    final archivedConversationBookmarksSet = bookmarsMap[BookmarksSetType.chats];

    return archivedConversationBookmarksSet?.data.communitiesIds ?? [];
  }

  Future<void> toogleConversation(List<ConversationListItem> conversations) async {
    final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);

    final archivedConversationBookmarksSet = bookmarksMap[BookmarksSetType.chats];

    final archivedConversationBookmarksSetData = archivedConversationBookmarksSet?.data ??
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

    final content = archivedConversationBookmarksSetData.content;

    final decryptedContent = content.isNotEmpty
        ? await e2eeService.decryptMessage(
            archivedConversationBookmarksSetData.content,
          )
        : archivedConversationBookmarksSetData.content;

    var parsedContent = decryptedContent.isNotEmpty
        ? (jsonDecode(decryptedContent) as List)
            .map((e) => (e as List).map((s) => s.toString()).toList())
            .toList()
        : null;

    var updatedBookmarksSet = archivedConversationBookmarksSetData;

    for (final conversation in conversations) {
      if (conversation.type == ConversationType.community) {
        final isArchived =
            archivedConversationBookmarksSetData.communitiesIds.contains(conversation.uuid);

        if (isArchived) {
          updatedBookmarksSet = updatedBookmarksSet.copyWith(
            communitiesIds: archivedConversationBookmarksSetData.communitiesIds
                .where((id) => id != conversation.uuid)
                .toList(),
          );
        } else {
          updatedBookmarksSet = updatedBookmarksSet.copyWith(
            communitiesIds: [
              ...updatedBookmarksSet.communitiesIds,
              conversation.uuid,
            ],
          );
        }
      } else {
        final encryptedGroupIds = CommunityIdentifierTag(value: conversation.uuid).toTag();

        if (parsedContent == null) {
          parsedContent = [
            encryptedGroupIds,
          ];
        } else {
          final existItem = parsedContent
              .firstWhereOrNull((element) => element.toString() == encryptedGroupIds.toString());
          if (existItem == null) {
            parsedContent.add(encryptedGroupIds);
          } else {
            parsedContent.remove(existItem);
          }
        }

        final encodedContent = parsedContent.isEmpty ? '' : jsonEncode(parsedContent);
        final encryptedContent = encodedContent.isNotEmpty
            ? await e2eeService.encryptMessage(encodedContent)
            : encodedContent;

        updatedBookmarksSet = updatedBookmarksSet.copyWith(
          content: encryptedContent,
        );
      }
    }

    await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
          updatedBookmarksSet..toReplaceableEventReference(currentUserPubkey),
        );
  }
}
