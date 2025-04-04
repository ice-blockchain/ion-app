// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/dao/coins_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/sync_coins_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
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

  Future<List<CoinData>> searchCoins(String query) => _coinsDao.search(query);

  Future<void> updateCoins(List<Coin> coins) => _coinsDao.upsertAll(coins);

  Future<void> updateCoinSyncQueue(List<SyncCoins> syncCoins) => _syncCoinsDao.insertAll(syncCoins);

  Future<List<SyncCoins>> getCoinSyncQueue() => _syncCoinsDao.load();

  Future<DateTime?> getNextSyncTime() => _syncCoinsDao.getNextSyncTime();

  Future<bool> hasSyncQueue() => _syncCoinsDao.hasAny();

  Future<void> removeSyncQueue() => _syncCoinsDao.clear();

  /// Returns a list of coins whose data expires after the specified date.
  Future<List<Coin>> getCoinsToSync(DateTime expirationDate) =>
      _syncCoinsDao.getCoinsToSync(expirationDate);

  /// Returns Stream of coins. Expects a list of coins to watch.
  /// If the [coins] list is not provided, all coins will be watched.
  Stream<List<CoinData>> watchCoins([Iterable<String>? coinIds]) => _coinsDao.watch(coinIds);

  /// Returns Future of coins. Expects a list of coins to get.
  /// If the [coins] list is not provided, all coins will be returned.
  Future<List<CoinData>> getCoins([Iterable<String>? coinIds]) => _coinsDao.get(coinIds);

  Future<CoinData> getNativeCoin(NetworkData network) =>
      getCoinsByFilters(networks: [network.id], contractAddresses: [''])
          .then((result) => result.first);

  Future<List<CoinData>> getCoinsByFilters({
    Iterable<String>? symbolGroups,
    Iterable<String>? symbols,
    Iterable<String>? networks,
    Iterable<String>? contractAddresses,
  }) =>
      _coinsDao.getByFilters(
        symbolGroups: symbolGroups,
        symbols: symbols,
        networks: networks,
        contractAddresses: contractAddresses,
      );

  int? getLastSyncTime() => _localStorage.getInt(_lastSyncTimeKey);

  int? getCoinsVersion() => _localStorage.getInt(_coinsVersionKey);

  Future<void> setLastSyncTime(int time) => _localStorage.setInt(_lastSyncTimeKey, time);

  Future<void> setCoinsVersion(int version) => _localStorage.setInt(_coinsVersionKey, version);
}
