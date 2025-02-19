// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:ion/app/extensions/bool.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_sync_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_sync_provider.c.g.dart';

@Riverpod(keepAlive: true)
class CoinsSync extends _$CoinsSync {
  @override
  Future<void> build() async {
    final authState = await ref.watch(authProvider.future);
    final appState = ref.watch(appLifecycleProvider);

    if (!authState.isAuthenticated || appState != AppLifecycleState.resumed) {
      return;
    }

    final coinSyncService = await ref.watch(coinsSyncServiceProvider.future);

    if (authState.isAuthenticated.falseOrValue) {
      await coinSyncService.syncAllCoins();
      coinSyncService.startPeriodicSync();
      ref.onDispose(coinSyncService.stopPeriodicSync);
      await coinSyncService.startActiveCoinsSyncQueue();
    } else {
      coinSyncService.removeActiveCoinsSyncQueue();
    }
  }
}
