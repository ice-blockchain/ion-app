import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followed_users_provider.g.dart';

//TODO::combine with user_following_provider
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
