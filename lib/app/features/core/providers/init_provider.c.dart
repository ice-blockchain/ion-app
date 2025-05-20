// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_sync_provider.c.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/core/providers/template_provider.c.dart';
import 'package:ion/app/features/core/providers/window_manager_provider.c.dart';
import 'package:ion/app/features/core/views/components/widget_error_builder.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/force_update/providers/force_update_provider.c.dart';
import 'package:ion/app/features/push_notifications/background/firebase_messaging_background_service.dart';
import 'package:ion/app/features/push_notifications/providers/pushes_init_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_sync_provider.c.dart';
import 'package:ion/app/features/wallets/providers/coins_sync_provider.c.dart';
import 'package:ion/app/features/wallets/providers/transactions_subscription_provider.c.dart';
import 'package:ion/app/features/wallets/providers/user_public_wallets_sync_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_initializer_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ion_connect_logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/utils/functions.dart';
import 'package:ion/l10n/timeago_locales.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<void> initApp(Ref ref) async {
  final featureFlagsNotifier = ref.read(featureFlagsProvider.notifier);
  final logIonConnect = featureFlagsNotifier.get(LoggerFeatureFlag.logIonConnect);

  ErrorWidget.builder = WidgetErrorBuilder.new;

  IonConnect.initialize(logIonConnect ? IonConnectLogger() : null);

  await Future.wait([
    ref.read(windowManagerProvider.notifier).show(),
    ref.read(sharedPreferencesProvider.future),
    ref.read(appTemplateProvider.future),
    ref.read(authProvider.future),
    ref.read(permissionsProvider.notifier).checkAllPermissions(),
    ref.read(onboardingCompleteProvider.future),
    ref.read(forceUpdateProvider.future),
  ]);

  // `ref.read` lets `coinsSyncProvider` be disposed even though it's a keepAlive provider
  // so we need to listen to it to keep it alive. The same with transactionsSubscription.
  ref
    ..listen(coinsSyncProvider, noop)
    ..listen(transactionsSubscriptionProvider, noop)
    ..listen(walletsInitializerNotifierProvider, noop)
    ..listen(userPublicWalletsSyncProvider, noop)
    ..listen(userRelaysSyncProvider, noop)
    ..listen(userChatRelaysSyncProvider, noop)
    ..listen(feedBookmarksSyncProvider, noop)
    ..listen(pushesInitProvider, noop);

  initFirebaseMessagingBackgroundHandler();

  registerTimeagoLocalesForEnum();
}
