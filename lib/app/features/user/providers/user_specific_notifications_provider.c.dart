// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/providers/account_notifications_sets_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_specific_notifications_provider.c.g.dart';

@riverpod
class UserSpecificNotifications extends _$UserSpecificNotifications {
  @override
  Future<List<UserNotificationsType>> build(String userPubkey) async {
    final notificationTypes = <UserNotificationsType>[];

    for (final type in UserNotificationsType.values) {
      if (type == UserNotificationsType.none) continue;

      final users = await ref.watch(usersForNotificationTypeProvider(type).future);
      if (users.contains(userPubkey)) {
        notificationTypes.add(type);
      }
    }

    return notificationTypes.isEmpty ? [UserNotificationsType.none] : notificationTypes;
  }

  Future<void> updateNotificationsForUser(
    String userPubkey,
    List<UserNotificationsType> selectedTypes,
  ) async {
    state = const AsyncValue.loading();

    try {
      final allTypes = [
        UserNotificationsType.posts,
        UserNotificationsType.stories,
        UserNotificationsType.articles,
        UserNotificationsType.videos,
      ];

      final shouldDisableAll =
          selectedTypes.contains(UserNotificationsType.none) || selectedTypes.isEmpty;

      if (shouldDisableAll) {
        for (final type in allTypes) {
          await removeUserFromNotificationSet(ref, userPubkey, type);
        }
        state = const AsyncValue.data([UserNotificationsType.none]);
      } else {
        for (final type in allTypes) {
          if (selectedTypes.contains(type)) {
            await addUserToNotificationSet(ref, userPubkey, type);
          } else {
            await removeUserFromNotificationSet(ref, userPubkey, type);
          }
        }
        state = AsyncValue.data(selectedTypes);
      }

      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
