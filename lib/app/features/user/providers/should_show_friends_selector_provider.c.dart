// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'should_show_friends_selector_provider.c.g.dart';

const _friendsCountThreshold = 3;

@riverpod
Future<bool> shouldShowFriendsSelector(Ref ref) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);
  final friendsCount = followList?.pubkeys.length ?? 0;

  return friendsCount >= _friendsCountThreshold;
}
