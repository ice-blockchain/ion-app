// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';
import 'package:ion/app/features/push_notifications/data/models/selected_push_categories_state.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_push_categories_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SelectedPushCategories extends _$SelectedPushCategories {
  @override
  SelectedPushCategoriesState build() {
    listenSelf((_, next) => _saveState(next));
    return _loadSavedState();
  }

  void toggleCategory(PushNotificationCategory category) {
    state = state.categories.contains(category)
        ? state.copyWith(categories: [...state.categories]..remove(category))
        : state.copyWith(categories: [...state.categories, category]);
  }

  void toggleSuspended() {
    state = state.copyWith(suspended: !state.suspended);
  }

  void _saveState(SelectedPushCategoriesState? state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null || state == null) {
      return;
    }
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_selectedPushCategoriesKey, jsonEncode(state.toJson()));
  }

  SelectedPushCategoriesState _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return _defaultState;
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final savedState = userPreferencesService.getValue<String>(_selectedPushCategoriesKey);

    if (savedState == null) {
      return _defaultState;
    }

    try {
      return SelectedPushCategoriesState.fromJson(jsonDecode(savedState) as Map<String, dynamic>);
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to load selected push categories',
      );
      return _defaultState;
    }
  }

  static const _defaultState = SelectedPushCategoriesState(
    categories: PushNotificationCategory.values,
    suspended: false,
  );

  static const _selectedPushCategoriesKey = 'selected_push_categories';
}
