// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_users_provider.g.dart';

@riverpod
Future<List<String>?> feedSearchUsers(
  FeedSearchUsersRef ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  return mockedUserData.values
      .toList()
      .where((user) => (user.name ?? user.pubkey).toLowerCase().contains(query.toLowerCase()))
      .map((user) => user.pubkey)
      .toList();
}
