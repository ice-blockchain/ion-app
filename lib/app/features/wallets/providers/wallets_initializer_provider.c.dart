// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coin_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/networks/networks_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_initializer_provider.c.g.dart';

/// Completes, when wallets db and all related services are ready to use.
@Riverpod(keepAlive: true)
class WalletsInitializerNotifier extends _$WalletsInitializerNotifier {
  Completer<void>? _completer;

  @override
  Future<void> build() async {
    // Create a new completer only if it doesn't exist or was already completed
    Logger.log('XXX: WalletsInitializerNotifier: creating completer');
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<void>();
    }

    // Just wait here, until user becomes authenticated and required data loaded
    Logger.log('XXX: WalletsInitializerNotifier: getting auth state');
    final authState = await ref.watch(authProvider.future);
    Logger.log('XXX: WalletsInitializerNotifier: getting pubkey');
    final pubkey = ref.watch(currentPubkeySelectorProvider);

    Logger.log('XXX: WalletsInitializerNotifier: checking if user is authenticated');
    if (authState.isAuthenticated && pubkey != null) {
      Logger.log('XXX: WalletsInitializerNotifier: getting coin initializer');
      final coinInitializer = ref.watch(coinInitializerProvider);
      Logger.log('XXX: WalletsInitializerNotifier: getting networks initializer');
      final networksInitializer = ref.watch(networksInitializerProvider);
      Logger.log('XXX: WalletsInitializerNotifier: getting sync transactions service');
      final syncServiceFuture = ref.watch(syncTransactionsServiceProvider.future);

      Logger.log('XXX: WalletsInitializerNotifier: initializing coin and networks');
      await Future.wait([
        coinInitializer.initialize(),
        networksInitializer.initialize(),
      ]);

      try {
        Logger.log('XXX: WalletsInitializerNotifier: initializing sync transactions service');
        final syncService = await syncServiceFuture;

        Logger.log('XXX: WalletsInitializerNotifier: syncing transactions');
        unawaited(
          syncService.sync(),
        );
      } catch (error, stackTrace) {
        Logger.error(
          error,
          stackTrace: stackTrace,
          message: 'XXX: WalletsInitializerNotifier: SyncTransactionsService.sync() failed',
        );
        rethrow;
      }

      // Only complete if not already completed
      if (!_completer!.isCompleted) {
        _completer!.complete();
      }
    } else {
      // Reset completer, if user logged out, so the services will be re-initialized after login
      _completer = Completer<void>();
    }

    return _completer!.future;
  }
}
