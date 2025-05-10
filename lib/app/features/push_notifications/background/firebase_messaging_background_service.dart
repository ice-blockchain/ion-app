// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/push_notifications/background/app_translations_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_data_payload.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/logger/logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationsService = LocalNotificationsService();
  await notificationsService.initialize();

  if (message.notification != null) {
    return;
  }

  final riverpod = ProviderContainer(observers: [Logger.talkerRiverpodObserver]);

  final translator = await riverpod.read(translatorProvider.future);
  final translation = await translator.translate((translations) => translations.version.toString());

  final data = IonConnectPushDataPayload.fromJson(message.data);

  //TODO: parse translations and use for title and body + add fallback if no translations found

  await notificationsService.showNotification(
    id: message.messageId.hashCode,
    title: data.title,
    body: translation ?? data.body,
    payload: message.data.toString(),
  );
}

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
