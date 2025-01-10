// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_dao.c.dart';
import 'package:ion/app/features/wallet/data/coins/database/coins_database.c.dart';
import 'package:ion/app/features/wallet/data/coins/database/sync_coins_dao.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_repository.c.g.dart';

@Riverpod(keepAlive: true)
CoinsRepository coinsRepository(Ref ref) => CoinsRepository(
      coinsDao: ref.watch(coinsDaoProvider),
      syncCoinsDao: ref.watch(syncCoinsDaoProvider),
    );

class CoinsRepository {
  CoinsRepository({
    required CoinsDao coinsDao,
    required SyncCoinsDao syncCoinsDao,
  })  : _coinsDao = coinsDao,
        _syncCoinsDao = syncCoinsDao;

  final CoinsDao _coinsDao;
  final SyncCoinsDao _syncCoinsDao;

  Future<bool> hasSavedCoins() => _coinsDao.hasAny();

  Future<void> updateCoins(List<Coin> coins) => _coinsDao.upsertAll(coins);

  Future<void> updateCoinSyncQueue(List<SyncCoins> syncCoins) => _syncCoinsDao.insertAll(syncCoins);

  Future<DateTime?> getNextSyncTime() => _syncCoinsDao.getNextSyncTime();

  Future<bool> hasSyncQueue() => _syncCoinsDao.hasAny();

  Future<void> removeSyncQueue() => _syncCoinsDao.clear();

  /// Returns a list of coins whose data expires after the specified date.
  Future<List<Coin>> getCoinsToSync(DateTime expirationDate) =>
      _syncCoinsDao.getCoinsToSync(expirationDate);

  Stream<List<Coin>> watchCoins() => _coinsDao.watchCoins();
}
