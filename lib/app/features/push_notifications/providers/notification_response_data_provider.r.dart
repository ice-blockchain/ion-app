// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/push_notifications/providers/configure_firebase_app_provider.r.dart';
import 'package:ion/app/features/push_notifications/providers/notification_response_service.r.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.r.dart';
import 'package:ion/app/services/local_notifications/local_notifications.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_data_provider.r.g.dart';

@Riverpod(keepAlive: true)
class NotificationResponseData extends _$NotificationResponseData {
  @override
  void build() {
    final firebaseAppConfigured = ref.watch(configureFirebaseAppProvider).valueOrNull ?? false;
    if (firebaseAppConfigured) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
    final localNotificationsService = await ref.watch(localNotificationsServiceProvider.future);

    // When the app is opened from a terminated state by a notification.
    // iOS only.
    // Notifications are handled there with a Notification Service Extension then passed to FCM SDK.
    final initialFcmNotificationData = await firebaseMessagingService.getInitialMessageData();
    if (initialFcmNotificationData != null) {
      _handlePushData(initialFcmNotificationData);
    }

    // When the app is opened from a terminated state by a notification.
    // Android only.
    // Notifications are handled there with a background service and presented via local notifications.
    final initialLocalNotificationData =
        await localNotificationsService.getInitialNotificationData();
    if (initialLocalNotificationData != null) {
      _handlePushData(initialLocalNotificationData);
    }

    // if the app is opened from a background state (not terminated) by pressing an FCM notification.
    final firebaseNotificationHandler =
        firebaseMessagingService.onMessageOpenedApp().listen(_handlePushData);

    // if the app is opened from a background state (not terminated) by pressing an local notification.
    final localNotificationHandler =
        localNotificationsService.notificationResponseStream.listen(_handlePushData);

    ref.onDispose(() {
      firebaseNotificationHandler.cancel();
      localNotificationHandler.cancel();
    });
  }

  void _handlePushData(Map<String, dynamic> data) {
    ref.read(notificationResponseServiceProvider).handleNotificationResponse(data);
  }
}
