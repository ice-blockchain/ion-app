// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_app_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_messaging_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/foreground_messages_handler_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_response_data_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_response_handler.c.dart';
import 'package:ion/app/features/push_notifications/providers/push_subscription_sync_provider.c.dart';
import 'package:ion/app/utils/functions.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pushes_init_provider.c.g.dart';

@riverpod
void pushesInit(Ref ref) {
  ref
    ..listen(configureFirebaseAppProvider, noop)
    ..listen(configureFirebaseMessagingProvider, noop)
    ..listen(pushSubscriptionSyncProvider, noop)
    ..listen(notificationResponseDataProvider, noop)
    ..listen(notificationResponseHandlerProvider, noop)
    ..listen(foregroundMessagesHandlerProvider, noop);
}
