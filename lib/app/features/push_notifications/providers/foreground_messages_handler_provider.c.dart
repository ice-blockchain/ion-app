import 'dart:convert';

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_app_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_data_parser_provider.c.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foreground_messages_handler_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ForegroundMessagesHandler extends _$ForegroundMessagesHandler {
  @override
  FutureOr<void> build() async {
    final firebaseAppConfigured = ref.watch(configureFirebaseAppProvider).valueOrNull ?? false;
    if (firebaseAppConfigured) {
      final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
      final subscription = firebaseMessagingService.onMessage().listen(_handleForegroundMessage);
      ref.onDispose(subscription.cancel);
    }
  }

  Future<void> _handleForegroundMessage(Map<String, dynamic> response) async {
    final data = IonConnectPushDataPayload.fromJson(response);

    if (await _shouldSkip(data: data)) {
      return;
    }

    final parser = await ref.read(notificationDataParserProvider.future);
    final parsedData = await parser.parse(data);

    final notificationsService = await ref.read(localNotificationsServiceProvider.future);

    await notificationsService.showNotification(
      id: generateUuid().hashCode,
      title: parsedData?.title ?? data.title,
      body: parsedData?.body ?? data.body,
      payload: jsonEncode(response),
    );
  }

  Future<bool> _shouldSkip({
    required IonConnectPushDataPayload data,
  }) async {
    // Skipping gift wraps with own events
    if (data.event.kind == IonConnectGiftWrapEntity.kind) {
      final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);
      final currentPubkey = ref.watch(currentPubkeySelectorProvider);

      if (currentPubkey == null) {
        return true;
      }

      final rumor = await giftUnwrapService.unwrap(data.event);

      return rumor.masterPubkey == currentPubkey;
    }
    return false;
  }
}
