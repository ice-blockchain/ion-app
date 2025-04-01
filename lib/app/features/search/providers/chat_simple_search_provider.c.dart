// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/user/providers/search_users_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_simple_search_provider.c.g.dart';

@riverpod
Future<Map<String, String>?> chatSimpleSearch(Ref ref, String query) async {
  if (query.isEmpty) return null;

  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentUserMasterPubkey == null) return null;

  // Fetch and sort search results
  final searchResults = ref.watch(searchUsersProvider(query: query));
  await Future<void>.delayed(const Duration(milliseconds: 500));
  final sortedUsers = (searchResults?.users ?? [])..sortBy((user) => user.data.displayName);
  final foundUsersPubkeysMap = {for (final user in sortedUsers) user.masterPubkey: ''};

  // Fetch and sort last conversation messages
  final lastConversationMessages = ref
          .watch(conversationsProvider)
          .value
          ?.map((conversation) => conversation.latestMessage)
          .nonNulls
          .toList() ??
      [];

  final lastConversationEntities = lastConversationMessages
      .map(PrivateDirectMessageEntity.fromEventMessage)
      .toList()
    ..sortBy((message) => message.createdAt);

  final conversationPubkeysMap = {
    for (final message in lastConversationEntities.reversed)
      message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey) ?? '':
          message.data.content,
  };

  // Filter conversations based on query
  final filteredConversationPubkeysMap = Map.fromEntries(
    await Future.wait(
      conversationPubkeysMap.entries.map((entry) async {
        final userMetadata = await ref.watch(userMetadataProvider(entry.key).future);
        if (userMetadata == null) return null;

        final nameMatches = userMetadata.data.name.contains(query);
        final displayNameMatches = userMetadata.data.displayName.contains(query);

        return (nameMatches || displayNameMatches) ? entry : null;
      }),
    ).then((entries) => entries.nonNulls),
  );

  // Combine and filter results
  final filteredAndSortedPubkeys = {
    ...filteredConversationPubkeysMap,
    ...Map.fromEntries(
      foundUsersPubkeysMap.entries
          .where((entry) => !filteredConversationPubkeysMap.containsKey(entry.key)),
    ),
  };

  return filteredAndSortedPubkeys;
}
