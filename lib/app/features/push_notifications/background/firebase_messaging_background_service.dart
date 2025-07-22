// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.r.dart';
import 'package:ion/app/features/chat/recent_chats/providers/money_message_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.r.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.f.dart';
import 'package:ion/app/features/push_notifications/providers/notification_data_parser_provider.r.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.r.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/local_notifications/local_notifications.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:ion/app/services/uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final riverpodContainer = ProviderContainer(
    observers: [Logger.talkerRiverpodObserver],
  );
  final notificationsService =
      await riverpodContainer.read(localNotificationsServiceProvider.future);

  IonConnect.initialize(null);

  if (message.notification != null) {
    return;
  }

  final data = await IonConnectPushDataPayload.fromEncoded(
    message.data,
    unwrapGift: (eventMassage) async {
      riverpodContainer.updateOverrides([
        currentUserIonConnectEventSignerProvider.overrideWith((ref) async {
          final savedIdentityKeyName = await ref.watch(currentIdentityKeyNameStoreProvider.future);
          if (savedIdentityKeyName != null) {
            return ref.watch(ionConnectEventSignerProvider(savedIdentityKeyName).future);
          }

          return null;
        }),
        encryptedMessageServiceProvider.overrideWith((ref) async {
          final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

          if (eventSigner == null) {
            throw EventSignerNotFoundException();
          }

          final sharedPreferencesFoundation =
              await ref.read(sharedPreferencesFoundationProvider.future);
          final currentUserPubkeyFromStorage =
              await sharedPreferencesFoundation.getString(CurrentPubkeySelector.persistenceKey);

          if (currentUserPubkeyFromStorage == null) {
            throw UserMasterPubkeyNotFoundException();
          }

          return EncryptedMessageService(
            eventSigner: eventSigner,
            currentUserPubkey: currentUserPubkeyFromStorage,
          );
        }),
        userDelegationProvider(eventMassage.pubkey).overrideWith((ref) async {
          return ref.watch(userDelegationFromDbProvider(eventMassage.pubkey));
        }),
      ]);

      final giftUnwrapService = await riverpodContainer.read(giftUnwrapServiceProvider.future);
      final event = await giftUnwrapService.unwrap(eventMassage);
      final userMetadata = riverpodContainer.read(userMetadataFromDbProvider(event.masterPubkey));

      return (event, userMetadata);
    },
  );

  final parser = await riverpodContainer.read(notificationDataParserProvider.future);
  final parsedData = await parser.parse(
    data,
    getFundsRequestData: (eventMessage) =>
        riverpodContainer.read(fundsRequestDisplayDataProvider(eventMessage).future),
    getTransactionData: (eventMessage) =>
        riverpodContainer.read(transactionDisplayDataProvider(eventMessage).future),
  );

  final title = parsedData?.title ?? message.notification?.title;
  final body = parsedData?.body ?? message.notification?.body;

  if (title == null || body == null) {
    return;
  }

  await notificationsService.showNotification(
    id: generateUuid().hashCode,
    title: title,
    body: body,
    payload: jsonEncode(message.data),
  );
}

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
