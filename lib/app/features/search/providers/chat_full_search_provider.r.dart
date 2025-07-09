// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.r.dart';
import 'package:ion/app/features/search/model/chat_search_result_item.f.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_full_search_provider.r.g.dart';

@riverpod
Future<List<ChatSearchResultItem>?> chatFullSearch(Ref ref, String query) async {
  if (query.isEmpty) return null;

  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentUserMasterPubkey == null) return null;

  final caseInsensitiveQuery = query.toLowerCase();

  final lastConversationMessages = ref
          .watch(conversationsProvider)
          .value
          ?.map((conversation) => conversation.latestMessage)
          .nonNulls
          .toList() ??
      [];

  final lastConversationEntities = lastConversationMessages
      .map(ReplaceablePrivateDirectMessageEntity.fromEventMessage)
      .toList()
    ..sortBy((message) => message.createdAt.toDateTime);

  final conversationsResults = lastConversationEntities.reversed.map(
    (message) => ChatSearchResultItem(
      masterPubkey:
          message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey) ?? '',
      lastMessageContent: message.data.content,
      isFromLocalDb: true,
    ),
  );

  final filteredConversationResults = await Future.wait(
    conversationsResults.map((entry) async {
      final userMetadata = await ref.watch(userMetadataProvider(entry.masterPubkey).future);
      if (userMetadata == null) return null;

      final nameMatches = userMetadata.data.name.toLowerCase().contains(caseInsensitiveQuery);
      final displayNameMatches =
          userMetadata.data.displayName.toLowerCase().contains(caseInsensitiveQuery);

      return (nameMatches || displayNameMatches) ? entry : null;
    }),
  ).then((entries) => entries.nonNulls);

  final eventMessageDao = ref.watch(eventMessageDaoProvider);
  final messagesSearchResults = await eventMessageDao.search(caseInsensitiveQuery);
  final entities =
      messagesSearchResults.map(ReplaceablePrivateDirectMessageEntity.fromEventMessage);

  final messageResults = entities.sortedBy((entity) => entity.createdAt.toDateTime).reversed.map(
        (message) => ChatSearchResultItem(
          masterPubkey:
              message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey) ?? '',
          lastMessageContent: message.data.content,
          isFromLocalDb: true,
        ),
      );

  return [...filteredConversationResults, ...messageResults];
}
