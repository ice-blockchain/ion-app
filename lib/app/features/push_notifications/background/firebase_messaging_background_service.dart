// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/push_notifications/background/app_translations_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/utils/string.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationsService = LocalNotificationsService();
  await notificationsService.initialize();
  IonConnect.initialize(null);

  if (message.notification != null) {
    return;
  }

  final data = IonConnectPushDataPayload.fromJson(message.data);
  final parsedData = await _parseNotificationData(data);

  await notificationsService.showNotification(
    id: message.messageId.hashCode,
    title: parsedData?.title ?? data.title,
    body: parsedData?.body ?? data.body,
    payload: message.data.toString(),
  );
}

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<({String title, String body})?> _parseNotificationData(
  IonConnectPushDataPayload data,
) async {
  final riverpod = ProviderContainer(observers: [Logger.talkerRiverpodObserver]);
  final translator = await riverpod.read(translatorProvider.future);
  final prefs = await riverpod.read(sharedPreferencesFoundationProvider.future);
  final currentPubkey = await prefs.getString(CurrentPubkeySelector.persistenceKey);

  if (currentPubkey == null) {
    return null;
  }

  final dataIsValid = await data.validate(currentPubkey: currentPubkey);

  if (!dataIsValid) {
    return null;
  }

  final notificationType = data.getNotificationType(currentPubkey: currentPubkey);

  if (notificationType == null) {
    return null;
  }

  final (title, body) =
      await _getNotificationTranslation(notificationType: notificationType, translator: translator);

  final placeholders = data.placeholders;

  return (
    title: replacePlaceholders(title ?? data.title, placeholders),
    body: replacePlaceholders(body ?? data.body, placeholders)
  );
}

Future<(String? title, String? body)> _getNotificationTranslation({
  required PushNotificationType notificationType,
  required Translator translator,
}) async {
  try {
    return switch (notificationType) {
      PushNotificationType.reply => await (
          translator.translate((t) => t.pushNotifications?.reply?.title),
          translator.translate((t) => t.pushNotifications?.reply?.body),
        ).wait,
      PushNotificationType.mention => await (
          translator.translate((t) => t.pushNotifications?.mention?.title),
          translator.translate((t) => t.pushNotifications?.mention?.body)
        ).wait,
      PushNotificationType.repost => await (
          translator.translate((t) => t.pushNotifications?.repost?.title),
          translator.translate((t) => t.pushNotifications?.repost?.body)
        ).wait,
      PushNotificationType.like => await (
          translator.translate((t) => t.pushNotifications?.like?.title),
          translator.translate((t) => t.pushNotifications?.like?.body)
        ).wait,
      PushNotificationType.follower => await (
          translator.translate((t) => t.pushNotifications?.follower?.title),
          translator.translate((t) => t.pushNotifications?.follower?.body)
        ).wait,
      PushNotificationType.chatReaction => await (
          translator.translate((t) => t.pushNotifications?.chatReaction?.title),
          translator.translate((t) => t.pushNotifications?.chatReaction?.body)
        ).wait,
      PushNotificationType.chatMessage => await (
          translator.translate((t) => t.pushNotifications?.chatMessage?.title),
          translator.translate((t) => t.pushNotifications?.chatMessage?.body)
        ).wait,
      PushNotificationType.paymentRequest => await (
          translator.translate((t) => t.pushNotifications?.paymentRequest?.title),
          translator.translate((t) => t.pushNotifications?.paymentRequest?.body)
        ).wait,
      PushNotificationType.paymentReceived => await (
          translator.translate((t) => t.pushNotifications?.paymentReceived?.title),
          translator.translate((t) => t.pushNotifications?.paymentReceived?.body)
        ).wait,
    };
  } catch (error) {
    return (null, null);
  }
}
