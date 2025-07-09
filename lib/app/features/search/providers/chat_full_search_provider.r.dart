// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_full_search_provider.r.g.dart';

@riverpod
Future<List<(String, String, bool)>?> chatFullSearch(Ref ref, String query) async {
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

  final conversationsTuples = lastConversationEntities.reversed.map(
    (message) => (
      message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey) ?? '',
      message.data.content,
      true,
    ),
  );

  final filteredConversationsTuples = await Future.wait(
    conversationsTuples.map((entry) async {
      final userMetadata = await ref.watch(userMetadataProvider(entry.$1).future);
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

  final messagesTuples = entities
      .sortedBy((entity) => entity.createdAt.toDateTime)
      .reversed
      .map(
        (message) => (
          message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey) ?? '',
          message.data.content,
          true,
        ),
      )
      .toList();

  return [...filteredConversationsTuples, ...messagesTuples];
}
