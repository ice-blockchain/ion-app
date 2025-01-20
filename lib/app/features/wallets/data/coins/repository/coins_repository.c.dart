// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/database/coins_dao.c.dart';
import 'package:ion/app/features/wallets/data/coins/database/coins_database.c.dart';
import 'package:ion/app/features/wallets/data/coins/database/sync_coins_dao.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_repository.c.g.dart';

@Riverpod(keepAlive: true)
CoinsRepository coinsRepository(Ref ref) => CoinsRepository(
      coinsDao: ref.watch(coinsDaoProvider),
      syncCoinsDao: ref.watch(syncCoinsDaoProvider),
      localStorage: ref.watch(localStorageProvider),
    );

class CoinsRepository {
  CoinsRepository({
    required CoinsDao coinsDao,
    required SyncCoinsDao syncCoinsDao,
    required LocalStorage localStorage,
  })  : _coinsDao = coinsDao,
        _syncCoinsDao = syncCoinsDao,
        _localStorage = localStorage;

  static const _lastSyncTimeKey = 'coins_last_sync_time';
  static const _coinsVersionKey = 'coins_version';

  final CoinsDao _coinsDao;
  final SyncCoinsDao _syncCoinsDao;
  final LocalStorage _localStorage;

  Future<bool> hasSavedCoins() => _coinsDao.hasAny();

  Future<List<Coin>> searchCoins(String query) => _coinsDao.search(query);

  Future<void> updateCoins(List<Coin> coins) => _coinsDao.upsertAll(coins);

  Future<void> updateCoinSyncQueue(List<SyncCoins> syncCoins) => _syncCoinsDao.insertAll(syncCoins);

  Future<DateTime?> getNextSyncTime() => _syncCoinsDao.getNextSyncTime();

  Future<bool> hasSyncQueue() => _syncCoinsDao.hasAny();

  Future<void> removeSyncQueue() => _syncCoinsDao.clear();

  /// Returns a list of coins whose data expires after the specified date.
  Future<List<Coin>> getCoinsToSync(DateTime expirationDate) =>
      _syncCoinsDao.getCoinsToSync(expirationDate);

  /// Returns Stream of coins. Expects a list of coins to watch.
  /// If the [coins] list is not provided, all coins will be watched.
  Stream<List<Coin>> watchCoins([List<Coin>? coins]) =>
      _coinsDao.watch(coins?.map((coin) => coin.id));

  /// Returns Future of coins. Expects a list of coins to get.
  /// If the [coins] list is not provided, all coins will be returned.
  Future<List<Coin>> getCoins([List<Coin>? coins]) => _coinsDao.get(coins?.map((coin) => coin.id));

  int? getLastSyncTime() => _localStorage.getInt(_lastSyncTimeKey);

  int? getCoinsVersion() => _localStorage.getInt(_coinsVersionKey);

  Future<void> setLastSyncTime(int time) => _localStorage.setInt(_lastSyncTimeKey, time);

  Future<void> setCoinsVersion(int version) => _localStorage.setInt(_coinsVersionKey, version);
}
