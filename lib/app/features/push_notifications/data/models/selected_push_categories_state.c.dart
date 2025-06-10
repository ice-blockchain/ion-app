// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';

part 'selected_push_categories_state.c.freezed.dart';
part 'selected_push_categories_state.c.g.dart';

@freezed
class SelectedPushCategoriesState with _$SelectedPushCategoriesState {
  const factory SelectedPushCategoriesState({
    required List<PushNotificationCategory> categories,
    required bool suspended,
  }) = _SelectedPushCategoriesState;

  const SelectedPushCategoriesState._();

  factory SelectedPushCategoriesState.fromJson(Map<String, dynamic> json) =>
      _$SelectedPushCategoriesStateFromJson(json);

  List<PushNotificationCategory> get enabledCategories => suspended ? [] : categories;
}
