// SPDX-License-Identifier: ice License 1.0

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseMessagingServiceProvider = Provider((Ref ref) {
  return FirebaseMessagingService();
});

class FirebaseMessagingService {
  /// Registers to receive remote notifications through Apple Push Notification service.
  ///
  /// Has no effect on Android & web.
  Future<void> registerForRemoteNotifications() {
    return FirebaseMessaging.instance.registerForRemoteNotifications();
  }

  Future<String?> getToken() {
    return FirebaseMessaging.instance.getToken();
  }
}
