// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_data_provider.c.g.dart';

@riverpod
Stream<Map<String, dynamic>> notificationResponseData(Ref ref) {
  final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
  final localNotificationsService = ref.watch(localNotificationsServiceProvider);

  final controller = StreamController<Map<String, dynamic>>();

  firebaseMessagingService.getInitialMessageData().then((data) {
    if (data != null) {
      controller.add(data);
    }
  });

  localNotificationsService.getInitialNotificationData().then((data) {
    if (data != null) {
      controller.add(data);
    }
  });

  final subscription = localNotificationsService.notificationResponseStream.listen(controller.add);

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream.distinct();
}
