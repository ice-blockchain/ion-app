// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:ion/app/features/push_notifications/providers/push_translations_sync_provider.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationsService = LocalNotificationsService();
  await notificationsService.initialize();

  if (message.notification != null) {
    return;
  }

  // final translations = await _getNotificationTranslations();

  //TODO: parse translations and use for title and body + add fallback if no translations found

  await notificationsService.showNotification(
    id: message.messageId.hashCode,
    title: 'No Title',
    body: 'No Body',
    payload: message.data.toString(),
  );
}

// Future<String?> _getNotificationTranslations() async {
//   final cachePath = await PushTranslationsRepository.cachePath;
//   final file = File(cachePath);
//   if (file.existsSync()) {
//     return file.readAsString();
//   }
//   return null;
// }

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
