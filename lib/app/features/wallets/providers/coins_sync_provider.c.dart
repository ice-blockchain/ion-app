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
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return;
    }

    final authState = await ref.watch(authProvider.future);
    final coinSyncService = await ref.watch(coinsSyncServiceProvider.future);
    final appState = ref.watch(appLifecycleProvider);

    if (appState != AppLifecycleState.resumed) {
      return;
    }

    if (authState.isAuthenticated.falseOrValue) {
      await coinSyncService.syncAllCoins();
      coinSyncService.startPeriodicSync();
      await coinSyncService.startActiveCoinsSyncQueue();
    } else {
      coinSyncService.removeActiveCoinsSyncQueue();
    }

    ref.onDispose(coinSyncService.stopPeriodicSync);
  }
}
