// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_push_categories_provider.c.g.dart';

typedef SelectedPushCategoriesState = List<PushNotificationCategory>;

@Riverpod(keepAlive: true)
class SelectedPushCategories extends _$SelectedPushCategories {
  @override
  List<PushNotificationCategory> build() {
    listenSelf((_, next) => _saveState(next));
    return _loadSavedState();
  }

  Future<void> setSelected(List<PushNotificationCategory> categories) async {
    state = categories;
  }

  void _saveState(SelectedPushCategoriesState? state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null || state == null) {
      return;
    }
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_selectedPushCategoriesKey, state.map((category) => category.name).toList());
  }

  SelectedPushCategoriesState _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return [];
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final savedState = userPreferencesService.getValue<List<String>>(_selectedPushCategoriesKey);

    if (savedState == null) {
      return [];
    }

    return savedState.map((category) => PushNotificationCategory.values.byName(category)).toList();
  }

  static const _selectedPushCategoriesKey = 'selected_push_categories';
}
