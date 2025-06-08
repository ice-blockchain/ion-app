// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:collection';

import 'package:ion/app/features/push_notifications/providers/configure_firebase_app_provider.c.dart';
import 'package:ion/app/services/providers/firebase/firebase_messaging_service_provider.c.dart';
import 'package:ion/app/services/providers/local_notifications/local_notifications.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_data_provider.c.g.dart';

typedef QueueData = Map<String, dynamic>;

@Riverpod(keepAlive: true)
class NotificationResponseData extends _$NotificationResponseData {
  @override
  Queue<QueueData> build() {
    final firebaseAppConfigured = ref.watch(configureFirebaseAppProvider).valueOrNull ?? false;
    if (firebaseAppConfigured) {
      _initialize();
    }
    return Queue<QueueData>();
  }

  Future<void> _initialize() async {
    final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
    final localNotificationsService = await ref.watch(localNotificationsServiceProvider.future);

    // When the app is opened from a terminated state by a notification.
    // iOS only.
    // Notifications are handled there with a Notification Service Extension then passed to FCM SDK.
    final initialFcmNotificationData = await firebaseMessagingService.getInitialMessageData();
    if (initialFcmNotificationData != null) {
      _addLast(initialFcmNotificationData);
    }

    // When the app is opened from a terminated state by a notification.
    // Android only.
    // Notifications are handled there with a background service and presented via local notifications.
    final initialLocalNotificationData =
        await localNotificationsService.getInitialNotificationData();
    if (initialLocalNotificationData != null) {
      _addLast(initialLocalNotificationData);
    }

    // if the app is opened from a background state (not terminated) by pressing an FCM notification.
    final firebaseNotificationHandler =
        firebaseMessagingService.onMessageOpenedApp().listen(_addLast);

    // if the app is opened from a background state (not terminated) by pressing an local notification.
    final localNotificationHandler =
        localNotificationsService.notificationResponseStream.listen(_addLast);

    ref.onDispose(() {
      firebaseNotificationHandler.cancel();
      localNotificationHandler.cancel();
    });
  }

  void _addLast(QueueData data) {
    state = Queue.from(state)..addLast(data);
  }

  void removeFirst() {
    if (state.isNotEmpty) {
      state = Queue.from(state)..removeFirst();
    }
  }
}
