// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_search_provider.r.g.dart';

@riverpod
Future<List<(String, String)>?> chatMessagesSearch(Ref ref, String query) async {
  if (query.isEmpty) return null;

  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentUserMasterPubkey == null) return null;

  final caseInsensitiveQuery = query.toLowerCase();

  final eventMessageDao = ref.watch(eventMessageDaoProvider);

  final searchResults = await eventMessageDao.search(caseInsensitiveQuery);

  final entities = searchResults.map(ReplaceablePrivateDirectMessageEntity.fromEventMessage);

  final tuples = entities
      .sortedBy((entity) => entity.createdAt.toDateTime)
      .reversed
      .map(
        (message) => (
          message.allPubkeys.firstWhereOrNull((key) => key != currentUserMasterPubkey) ?? '',
          message.data.content
        ),
      )
      .toList();

  return tuples;
}
