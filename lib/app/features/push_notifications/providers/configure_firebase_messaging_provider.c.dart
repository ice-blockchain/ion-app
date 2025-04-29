// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configure_firebase_messaging_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ConfigureFirebaseMessaging extends _$ConfigureFirebaseMessaging {
  @override
  Future<void> build() async {}

  void _test(List<PushNotificationCategory> categories) {
    for (final category in categories) {
      if (category is IonConnectPushNotificationCategory) {
        // Handle IonConnectPushNotificationCategory
      } else {
        // Handle other categories
      }
    }
  }
}
