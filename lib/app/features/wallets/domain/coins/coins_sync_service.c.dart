// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/coins/database/coins_database.c.dart' as db;
import 'package:ion/app/features/wallets/data/coins/repository/coins_repository.c.dart';
<<<<<<<< HEAD:lib/app/features/wallets/domain/coins/coins_sync_service.c.dart
import 'package:ion/app/features/wallets/domain/coins/coins_mapper.dart';
import 'package:ion/app/features/wallets/model/network.dart';
========
import 'package:ion/app/features/wallets/domain/coins_mapper.dart';
>>>>>>>> 341595ac (chore: add service for searching):lib/app/features/wallets/domain/coins_sync_service.c.dart
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_sync_service.c.g.dart';

@riverpod
Future<CoinsSyncService> coinsSyncService(Ref ref) async {
<<<<<<<< HEAD:lib/app/features/wallets/domain/coins/coins_sync_service.c.dart
========
  await ref.watch(sharedPreferencesProvider.future);

>>>>>>>> 341595ac (chore: add service for searching):lib/app/features/wallets/domain/coins_sync_service.c.dart
  return CoinsSyncService(
    ref.watch(coinsRepositoryProvider),
    await ref.watch(ionIdentityClientProvider.future),
  );
}

class CoinsSyncService {
<<<<<<<< HEAD:lib/app/features/wallets/domain/coins/coins_sync_service.c.dart
CoinsSyncService(
========
  CoinsSyncService(
>>>>>>>> 341595ac (chore: add service for searching):lib/app/features/wallets/domain/coins_sync_service.c.dart
    this._coinsRepository,
    this._ionIdentityClient,
  );

  static const _timerInterval = Duration(hours: 1);
  static const _syncInterval = Duration(days: 1);
  Timer? _syncTimer;

  final CoinsRepository _coinsRepository;
  final IONIdentityClient _ionIdentityClient;

  var _syncQueueActive = false;
  var _syncQueueInitialized = false;

  void startPeriodicSync() {
    stopPeriodicSync();
    _syncTimer = Timer.periodic(_timerInterval, (_) => syncAllCoins());
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> syncAllCoins() async {
    final lastSyncTime = _coinsRepository.getLastSyncTime();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final syncInterval = _syncInterval.inMilliseconds;

    if (lastSyncTime != null && currentTime - lastSyncTime < syncInterval) {
      return;
    }

    final version = _coinsRepository.getCoinsVersion() ?? 0;
    final response = await _ionIdentityClient.coins.getCoins(currentVersion: version);

    await (
      _coinsRepository.setCoinsVersion(response.version),
      _coinsRepository.setLastSyncTime(currentTime),
    ).wait;

    if (response.coins.isEmpty) {
      return;
    }

    await saveCoins(response.coins);
    await _updateCoinsSyncQueue(
      response.coins.map(
        (coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency),
      ),
    );
  }

  Future<void> startActiveCoinsSyncQueue() async {
    Future<bool> isQueueNotReady() async => !(await _coinsRepository.hasSyncQueue());

    if (await isQueueNotReady()) {
      // Since we have different ways to add first coins data into database,
      // we need one place to detect first coins insert to build the sync queue
      final completer = Completer<void>();
      final subscription = _coinsRepository.watchCoins().listen((coins) async {
        if (coins.isNotEmpty) {
          if (await isQueueNotReady()) {
            await _updateCoinsSyncQueue(
              coins.map(
                (coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency),
              ),
            );
          }
          completer.complete();
        }
      });

      await completer.future;
      await subscription.cancel();
    }

    if (!_syncQueueInitialized) {
      _syncQueueActive = true;
      unawaited(syncActiveCoins());
    }
  }

  void removeActiveCoinsSyncQueue() {
    Logger.log('Remove active coins sync queue');

    _stopActiveCoinsSyncQueue();
    _coinsRepository.removeSyncQueue();
  }

  void _stopActiveCoinsSyncQueue() {
    _syncQueueActive = false;
    _syncQueueInitialized = false;
  }

  Future<void> saveCoins(Iterable<Coin> coinsDTO) async {
    final allowedNetworks = Network.values.map((e) => e.serverName.toLowerCase());

    await _coinsRepository.updateCoins(
      CoinsMapper().fromDtoToDb(
        coinsDTO.where((coin) {
          final result = allowedNetworks.contains(coin.network.toLowerCase());
          if (!result) {
            Logger.info('Skip coin ${coin.symbol}');
          }
          return result;
        }),
      ),
    );
  }

  Future<void> syncActiveCoins() async {
    final nextUpdate = await _coinsRepository.getNextSyncTime();

    if (nextUpdate == null || !_syncQueueActive) {
      // There are no coins to sync or sync queue was disabled
      _stopActiveCoinsSyncQueue();
      return;
    }

    _syncQueueInitialized = true;

    final difference = nextUpdate.difference(DateTime.now());
    Logger.log(
      'Active coins queue is active. The next sync will be on the $nextUpdate',
    );

    if (!difference.isNegative) {
      // Wait until first group in queue should be synced
      await Future<void>.delayed(difference.abs());
    }

    // Sync queue was disabled during delay, stop syncing
    if (!_syncQueueActive) return;

    final coins = await _coinsRepository.getCoinsToSync(DateTime.now());

    if (coins.isNotEmpty) {
      final syncedCoinsData =
          await _ionIdentityClient.coins.syncCoins(coins.map((e) => e.symbolGroup).toSet());

      final syncedCoins = syncedCoinsData.map((coinDTO) {
        final coinDB = coins.firstWhere((coin) => coin.id == coinDTO.id);
        return coinDTO.copyWith(
          name: coinDB.name,
          symbol: coinDB.symbol,
          iconURL: coinDB.iconURL,
          network: coinDB.network,
          decimals: coinDB.decimals,
          symbolGroup: coinDB.symbolGroup,
          syncFrequency: coinDB.syncFrequency,
          contractAddress: coinDB.contractAddress,
        );
      });
      await saveCoins(syncedCoins);
      // final syncedCoins = coins.map((coin) {
      //   final syncedData = syncedCoinsData.firstWhere((e) => e.symbolGroup == coin.symbolGroup);
      //
      //   return coin.copyWith(

      //   );
      // }).toList();
      // await _coinsRepository.updateCoins(syncedCoins);

      await _updateCoinsSyncQueue(
        syncedCoins.map(
          (coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency),
        ),
      );
    }

    // First section (coins with the same syncFrequency)
    // in the queue was updated, move on to the next syncFrequency group of coins
    unawaited(syncActiveCoins());
  }

  Future<void> _updateCoinsSyncQueue(
    Iterable<({String coinId, Duration syncFrequency})> coins,
  ) async {
    final currentDate = DateTime.now();

    await _coinsRepository.updateCoinSyncQueue(
      coins.map(
        (coin) {
          return db.SyncCoins(
            coinId: coin.coinId,
            syncAfter: currentDate.add(coin.syncFrequency),
          );
        },
      ).toList(),
    );
  }

  Future<void> saveCoinsVersion(int coinsVersion) async {
    await _coinsRepository.setCoinsVersion(coinsVersion);
  }

  Future<bool> hasSavedCoins() => _coinsRepository.hasSavedCoins();
}
