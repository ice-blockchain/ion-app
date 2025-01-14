// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/bool.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallet/data/coins/domain/coin_sync_service.c.dart';

class CoinsSyncWrapper extends HookConsumerWidget {
  const CoinsSyncWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAuthenticated = ref.watch(authProvider).valueOrNull?.hasAuthenticated;
    final coinSyncService = ref.watch(coinSyncServiceProvider).valueOrNull;
    final appState = useAppLifecycleState();

    useEffect(
      () {
        if (coinSyncService == null || appState != AppLifecycleState.resumed) {
          return null;
        }

        if (hasAuthenticated.falseOrValue) {
          coinSyncService
            ..syncAllCoins()
            ..startPeriodicSync()
            ..startActiveCoinsSyncQueue();
        } else {
          coinSyncService.removeActiveCoinsSyncQueue();
        }

        return coinSyncService.stopPeriodicSync;
      },
      [coinSyncService, appState, hasAuthenticated],
    );

    return child;
  }
}
