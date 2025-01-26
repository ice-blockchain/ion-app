// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'has_friends_selector_provider.c.g.dart';

@riverpod
Future<bool?> hasFriendsSelector(Ref ref) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);
  return followList?.pubkeys.isNotEmpty;
}
