// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:ion/app/extensions/bool.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.r.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_sync_service.r.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/sync_wallet_views_coins_service.r.dart';
import 'package:ion/app/features/wallets/providers/wallets_initializer_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_sync_provider.r.g.dart';

@Riverpod(keepAlive: true)
class CoinsSync extends _$CoinsSync {
  @override
  Future<void> build() async {
    final authState = await ref.watch(authProvider.future);
    final appState = ref.watch(appLifecycleProvider);

    if (!authState.isAuthenticated || appState != AppLifecycleState.resumed) {
      return;
    }

    // Wait until all necessary wallets components are initialized
    await ref.watch(walletsInitializerNotifierProvider.future);

    final coinSyncService = await ref.watch(coinsSyncServiceProvider.future);
    final walletViewsCoinsSyncService = await ref.watch(syncWalletViewCoinsServiceProvider.future);

    if (authState.isAuthenticated.falseOrValue) {
      await coinSyncService.syncAllCoins();
      coinSyncService.startPeriodicSync();
      ref.onDispose(coinSyncService.stopPeriodicSync);
    } else {
      walletViewsCoinsSyncService.removeQueue();
    }
  }
}
