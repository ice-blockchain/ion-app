// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/search_users_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_simple_search_provider.c.g.dart';

@riverpod
Future<List<String>?> chatSimpleSearch(Ref ref, String query) async {
  if (query.isEmpty) return null;

  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentUserMasterPubkey == null) return null;

  final searchResults = ref.watch(searchUsersProvider(query: query));

  final sortedUsers = List<UserMetadataEntity>.from(searchResults?.users ?? [])
    ..sortBy<String>((user) => user.data.displayName);

  final foundUsersMasterPubkeys = sortedUsers.map((user) => user.masterPubkey);

  // Debounce users search results
  await Future<void>.delayed(const Duration(milliseconds: 700));

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
    ..sortBy<DateTime>((message) => message.createdAt);

  final conversationMasterPubkeys = lastConversationEntities.reversed
      .map(
        (message) => message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey),
      )
      .nonNulls;

  final filteredConversationMasterPubkeys = (await Future.wait(
    conversationMasterPubkeys.map((masterPubkey) async {
      final userMetadata = await ref.watch(userMetadataProvider(masterPubkey).future);

      if (userMetadata == null) return null;

      return userMetadata.data.name.contains(query) || userMetadata.data.displayName.contains(query)
          ? masterPubkey
          : null;
    }),
  ))
      .nonNulls
      .toList();

  final filteredAndSortedPubkeys = [
    ...filteredConversationMasterPubkeys,
    ...foundUsersMasterPubkeys.where(
      (pubkey) => !filteredConversationMasterPubkeys.contains(pubkey),
    ),
  ].toList();

  return filteredAndSortedPubkeys;
}
