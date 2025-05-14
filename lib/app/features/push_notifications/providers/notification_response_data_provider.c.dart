// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:collection';

import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_data_provider.c.g.dart';

typedef QueueData = Map<String, dynamic>;

@Riverpod(keepAlive: true)
class NotificationResponseData extends _$NotificationResponseData {
  @override
  Queue<QueueData> build() {
    _initialize();
    return Queue<QueueData>();
  }

  Future<void> _initialize() async {
    final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
    final localNotificationsService = await ref.watch(localNotificationsServiceProvider.future);

    final firebaseInitialMessageData = await firebaseMessagingService.getInitialMessageData();
    if (firebaseInitialMessageData != null) {
      _addLast(firebaseInitialMessageData);
    }

    final initialLocalNotificationData =
        await localNotificationsService.getInitialNotificationData();
    if (initialLocalNotificationData != null) {
      _addLast(initialLocalNotificationData);
    }

    final subscription = localNotificationsService.notificationResponseStream.listen(_addLast);

    ref.onDispose(subscription.cancel);
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
