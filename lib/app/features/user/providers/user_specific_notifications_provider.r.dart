// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/account_notifications_sets.f.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/providers/account_notifications_sets_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_specific_notifications_provider.r.g.dart';

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
        final removeFutures = allTypes.map(
          (type) => _removeUserFromNotificationSet(userPubkey, type),
        );
        await Future.wait(removeFutures);

        state = const AsyncValue.data([UserNotificationsType.none]);
      } else {
        final updateFutures = allTypes.map((type) async {
          if (selectedTypes.contains(type)) {
            await _addUserToNotificationSet(userPubkey, type);
          } else {
            await _removeUserFromNotificationSet(userPubkey, type);
          }
        });
        await Future.wait(updateFutures);

        state = AsyncValue.data(selectedTypes);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _addUserToNotificationSet(
    String userPubkey,
    UserNotificationsType notificationType,
  ) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null || notificationType == UserNotificationsType.none) {
      return;
    }

    final setType = _getSetTypeForNotificationType(notificationType);
    if (setType == null) {
      return;
    }

    final currentUsers = await ref.read(usersForNotificationTypeProvider(notificationType).future);

    final updatedUsers =
        currentUsers.contains(userPubkey) ? currentUsers : [...currentUsers, userPubkey];

    await _updateNotificationSet(ref, currentPubkey, setType, updatedUsers);

    ref.invalidate(usersForNotificationTypeProvider(notificationType));
  }

  Future<void> _removeUserFromNotificationSet(
    String userPubkey,
    UserNotificationsType notificationType,
  ) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null || notificationType == UserNotificationsType.none) {
      return;
    }

    final setType = _getSetTypeForNotificationType(notificationType);
    if (setType == null) {
      return;
    }

    final currentUsers = await ref.read(usersForNotificationTypeProvider(notificationType).future);

    final updatedUsers = currentUsers.where((pubkey) => pubkey != userPubkey).toList();

    await _updateNotificationSet(ref, currentPubkey, setType, updatedUsers);

    ref.invalidate(usersForNotificationTypeProvider(notificationType));
  }

  Future<void> _updateNotificationSet(
    Ref ref,
    String currentPubkey,
    String setType,
    List<String> userPubkeys,
  ) async {
    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);

    final setData = AccountNotificationSetData(
      type: AccountNotificationSetType.values.firstWhere(
        (t) => t.dTagName == setType,
        orElse: () => AccountNotificationSetType.posts,
      ),
      userPubkeys: userPubkeys,
    );

    await ionConnectNotifier.sendEntityData(setData);
  }

  String? _getSetTypeForNotificationType(UserNotificationsType notificationType) {
    final setType = AccountNotificationSetType.fromUserNotificationType(notificationType);
    return setType?.dTagName;
  }
}
