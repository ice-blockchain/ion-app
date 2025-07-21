// SPDX-License-Identifier: ice License 1.0

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_messaging_service_provider.r.g.dart';

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

  Future<void> deleteToken() {
    return FirebaseMessaging.instance.deleteToken();
  }

  Stream<String> onTokenRefresh() {
    return FirebaseMessaging.instance.onTokenRefresh;
  }

  Stream<Map<String, dynamic>> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp.map((message) => message.data);
  }

  Stream<RemoteMessage> onMessage() => FirebaseMessaging.onMessage;

  Future<Map<String, dynamic>?> getInitialMessageData() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    return initialMessage?.data;
  }
}

@Riverpod(keepAlive: true)
FirebaseMessagingService firebaseMessagingService(Ref ref) => FirebaseMessagingService();
