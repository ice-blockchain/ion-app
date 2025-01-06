// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_repository.c.dart';
import 'package:ion/app/features/wallet/data/coins/domain/coins_mapper.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_sync_service.c.g.dart';

@riverpod
Future<CoinSyncService> coinSyncService(Ref ref) async {
  final interactor = CoinSyncService(
    ref.watch(coinsRepositoryProvider),
    ref.watch(localStorageProvider),
    await ref.watch(ionIdentityClientProvider.future),
  );

  return interactor;
}

class CoinSyncService {
  CoinSyncService(
    this._coinsRepository,
    this._localStorage,
    this._ionIdentityClient,
  );

  static const _timerInterval = Duration(hours: 1);
  static const _syncInterval = Duration(days: 1);
  Timer? _syncTimer;

  final CoinsRepository _coinsRepository;
  final LocalStorage _localStorage;
  final IONIdentityClient _ionIdentityClient;

  void startPeriodicSync() {
    stopPeriodicSync();
    _syncTimer = Timer.periodic(_timerInterval, (_) => syncCoins());
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> syncCoins() async {
    final lastSyncTime = _localStorage.getInt('coins_last_sync_time');
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final syncInterval = _syncInterval.inMilliseconds;

    if (lastSyncTime != null && currentTime - lastSyncTime < syncInterval) {
      return;
    }

    final version = _localStorage.getInt('coins_version');
    final response = await _ionIdentityClient.coins.getCoins(currentVersion: version ?? 0);

    await (
      _localStorage.setInt('coins_version', response.version),
      _localStorage.setInt('coins_last_sync_time', currentTime),
    ).wait;

    if (response.coins.isEmpty) {
      return;
    }

    await _coinsRepository.upsertAll(CoinsMapper.fromIONIdentityCoins(response.coins));
  }
}
