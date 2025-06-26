// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifications_provider.r.g.dart';

@Riverpod(keepAlive: true)
class UserNotificationsNotifier extends _$UserNotificationsNotifier {
  static const userNotificationsKey = 'UserPreferences:notifications';

  @override
  List<UserNotificationsType> build() {
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: currentIdentityKeyName));

    final savedTypes =
        userPreferencesService.getValue<List<String>>(userNotificationsKey) ?? ['none'];

    return savedTypes
        .map(
          (type) => UserNotificationsType.values.firstWhere(
            (t) => t.name == type,
            orElse: () => UserNotificationsType.none,
          ),
        )
        .toList();
  }

  void updateNotifications(List<UserNotificationsType> types) {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: currentIdentityKeyName));

    state = types;

    userPreferencesService.setValue(
      userNotificationsKey,
      types.map((type) => type.name).toList(),
    );
  }
}
