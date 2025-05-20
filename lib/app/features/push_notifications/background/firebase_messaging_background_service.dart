// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_data_parser_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final riverpodContainer = ProviderContainer(observers: [Logger.talkerRiverpodObserver]);
  final notificationsService =
      await riverpodContainer.read(localNotificationsServiceProvider.future);

  IonConnect.initialize(null);

  if (message.notification != null) {
    return;
  }

  final data = await IonConnectPushDataPayload.fromEncoded(message.data);
  final parser = await riverpodContainer.read(notificationDataParserProvider.future);
  final parsedData = await parser.parse(data);

  if (parsedData == null) {
    return;
  }

  await notificationsService.showNotification(
    id: generateUuid().hashCode,
    title: parsedData.title,
    body: parsedData.body,
    payload: jsonEncode(message.data),
  );
}

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
