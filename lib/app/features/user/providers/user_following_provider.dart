import 'dart:math';

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_following_provider.g.dart';

@Riverpod(keepAlive: true)
class UserFollowing extends _$UserFollowing {
  @override
  Future<Set<String>> build(String userId) async {
    await Future<void>.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
    return mockedUserData.values.toList().sublist(2).map((user) => user.id).toSet();
  }

  Future<void> toggleFollow(String userId) async {
    final stateValue = state.valueOrNull;
    if (stateValue == null) return;

    if (stateValue.contains(userId)) {
      state = AsyncValue.data({...stateValue}..remove(userId));
    } else {
      state = AsyncValue.data({...stateValue}..add(userId));
    }
  }
}

@riverpod
bool isCurrentUserFollowingSelector(IsCurrentUserFollowingSelectorRef ref, String userId) {
  final currentUserId = ref.watch(currentUserIdSelectorProvider);
  return ref.watch(userFollowingProvider(currentUserId)
      .select((state) => state.valueOrNull?.contains(userId) ?? false));
}
