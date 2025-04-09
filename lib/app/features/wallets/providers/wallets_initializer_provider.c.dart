// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coin_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/networks/networks_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_initializer_provider.c.g.dart';

/// Completes, when wallets db and all related services are ready to use.
@Riverpod(keepAlive: true)
class WalletsInitializerNotifier extends _$WalletsInitializerNotifier {
  Completer<void>? _completer;

  @override
  Future<void> build() async {
    // Since this method may be retriggered if some dependency changes,
    // we also need to check if the completer was completed earlier.
    // If so, we need to create a new one.
    _completer = _completer == null || _completer!.isCompleted ? Completer<void>() : _completer;

    // Just wait here, until user becomes authenticated
    final authState = await ref.watch(authProvider.future);

    if (authState.isAuthenticated) {
      final coinInitializer = ref.watch(coinInitializerProvider);
      final networksInitializer = ref.watch(networksInitializerProvider);
      final syncServiceFuture = ref.watch(syncTransactionsServiceProvider.future);

      await Future.wait([
        coinInitializer.initialize(),
        networksInitializer.initialize(),
        syncServiceFuture.then((service) => service.sync()),
      ]);

      _completer?.complete();
    } else {
      // Reset completer, if user logged out, so the services will be re-initialized after login
      _completer = Completer<void>();
    }

    return _completer!.future;
  }
}
