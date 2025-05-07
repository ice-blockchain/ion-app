import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationsService = LocalNotificationsService();
  await notificationsService.initialize();

  if (message.notification != null) {
    return;
  }

  await notificationsService.showNotification(
    id: message.messageId.hashCode,
    title: 'No Title',
    body: 'No Body',
    payload: message.data.toString(),
  );
}

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
