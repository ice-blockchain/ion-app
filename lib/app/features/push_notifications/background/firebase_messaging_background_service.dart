// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/app_translations_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/utils/string.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final riverpodContainer = ProviderContainer(observers: [Logger.talkerRiverpodObserver]);
  final notificationsService =
      await riverpodContainer.read(localNotificationsServiceProvider.future);
  final translator = await riverpodContainer.read(pushTranslatorProvider.future);
  final localStorage = await riverpodContainer.read(localStorageAsyncProvider.future);

  IonConnect.initialize(null);

  if (message.notification != null) {
    return;
  }

  final data = IonConnectPushDataPayload.fromJson(message.data);
  final parsedData =
      await _parseNotificationData(data, translator: translator, localStorage: localStorage);

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
  IonConnectPushDataPayload data, {
  required Translator<PushNotificationTranslations> translator,
  required LocalStorage localStorage,
}) async {
  final currentPubkey = localStorage.getString(CurrentPubkeySelector.persistenceKey);

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
  required Translator<PushNotificationTranslations> translator,
}) async {
  try {
    return switch (notificationType) {
      PushNotificationType.reply => (
          await translator.translate((t) => t.reply?.title),
          await translator.translate((t) => t.reply?.body),
        ),
      PushNotificationType.mention => (
          await translator.translate((t) => t.mention?.title),
          await translator.translate((t) => t.mention?.body)
        ),
      PushNotificationType.repost => (
          await translator.translate((t) => t.repost?.title),
          await translator.translate((t) => t.repost?.body)
        ),
      PushNotificationType.like => (
          await translator.translate((t) => t.like?.title),
          await translator.translate((t) => t.like?.body)
        ),
      PushNotificationType.follower => (
          await translator.translate((t) => t.follower?.title),
          await translator.translate((t) => t.follower?.body)
        ),
      PushNotificationType.chatReaction => (
          await translator.translate((t) => t.chatReaction?.title),
          await translator.translate((t) => t.chatReaction?.body)
        ),
      PushNotificationType.chatMessage => (
          await translator.translate((t) => t.chatMessage?.title),
          await translator.translate((t) => t.chatMessage?.body)
        ),
      PushNotificationType.paymentRequest => (
          await translator.translate((t) => t.paymentRequest?.title),
          await translator.translate((t) => t.paymentRequest?.body)
        ),
      PushNotificationType.paymentReceived => (
          await translator.translate((t) => t.paymentReceived?.title),
          await translator.translate((t) => t.paymentReceived?.body)
        ),
    };
  } catch (error) {
    return (null, null);
  }
}
