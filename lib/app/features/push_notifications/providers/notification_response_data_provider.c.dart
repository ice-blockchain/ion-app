// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_data_provider.c.g.dart';

@riverpod
Future<StreamQueue<Map<String, dynamic>>> notificationResponseData(Ref ref) async {
  final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
  final localNotificationsService = await ref.watch(localNotificationsServiceProvider.future);

  final controller = StreamController<Map<String, dynamic>>();
  final streamQueue = StreamQueue(controller.stream.distinct());

  final firebaseInitialMessageData = await firebaseMessagingService.getInitialMessageData();

  if (firebaseInitialMessageData != null) {
    controller.add(firebaseInitialMessageData);
  }

  final initialLocalNotificationData = await localNotificationsService.getInitialNotificationData();
  if (initialLocalNotificationData != null) {
    controller.add(initialLocalNotificationData);
  }

  final subscription = localNotificationsService.notificationResponseStream.listen(controller.add);

  ref.onDispose(() {
    subscription.cancel();
    streamQueue.cancel();
    controller.close();
  });

  return streamQueue;
}
