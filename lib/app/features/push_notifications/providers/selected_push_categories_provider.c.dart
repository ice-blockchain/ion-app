// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_push_categories_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SelectedPushCategories extends _$SelectedPushCategories {
  @override
  Future<List<PushNotificationCategory>> build() async {
    return [];
  }

  Future<void> setSelected(List<PushNotificationCategory> categories) async {
    state = AsyncData(categories);
  }
}
