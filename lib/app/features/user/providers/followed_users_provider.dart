import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followed_users_provider.g.dart';

@riverpod
class FollowedUsers extends _$FollowedUsers {
  @override
  Set<String> build() {
    ref.watch(currentUserIdSelectorProvider);
    return {};
  }

  Future<void> toggleFollow(String userId) async {
    if (state.contains(userId)) {
      state = {...state}..remove(userId);
    } else {
      state = {...state}..add(userId);
    }
  }
}

@riverpod
bool isUserFollowedSelector(IsUserFollowedSelectorRef ref, String userId) {
  return ref.watch(followedUsersProvider.select((state) => state.contains(userId)));
}
