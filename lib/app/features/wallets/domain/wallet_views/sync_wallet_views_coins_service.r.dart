// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.r.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_wallet_views_coins_service.r.g.dart';

@riverpod
Future<SyncWalletViewCoinsService> syncWalletViewCoinsService(Ref ref) async {
  final service = SyncWalletViewCoinsService(
    coinsRepository: ref.watch(coinsRepositoryProvider),
    ionIdentityClient: await ref.watch(ionIdentityClientProvider.future),
  );

  ref.onDispose(service._stopQueue);

  return service;
}

class SyncWalletViewCoinsService {
  SyncWalletViewCoinsService({
    required CoinsRepository coinsRepository,
    required IONIdentityClient ionIdentityClient,
  })  : _coinsRepository = coinsRepository,
        _ionIdentityClient = ionIdentityClient;

  static const _syncThreshold = Duration(seconds: 3);

  final CoinsRepository _coinsRepository;
  final IONIdentityClient _ionIdentityClient;

  Timer? _syncTimer;
  bool _syncInProgress = false;
  bool _isSyncQueueRunning = false;

  Future<void> start(List<CoinData> coins) async {
    final coinIds = coins.map((coin) => coin.id).toSet();

    Future<bool> isQueueNotReady() async => !(await _coinsRepository.isSyncQueueReady(coinIds));

    if (await isQueueNotReady()) {
      // We need to be sure, that coins from the WalletView already in the DB,
      // so we wait to get them from there. This is the entry point to the queue,
      // so before we start the periodic sync, we need to make sure that it only contains the coins
      // that are in WalletViews. So if the isQueueNotReady returns false in the stream,
      // we tell the sync method to remove the coins that are not in WalletViews from the queue
      // and add new ones.
      final coins =
          await _coinsRepository.watchCoins(coinIds).firstWhere((result) => result.isNotEmpty);
      if (await isQueueNotReady()) {
        Logger.log(
          'The queue needs to be created/updated as it does not match the selected coins.',
        );

        await _updateCoinsSyncQueue(
          coins.map(
            (coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency),
          ),
          updateOnlyDifferences: true,
        );
      }
    }

    if (!_isSyncQueueRunning) {
      _isSyncQueueRunning = true;
      await _scheduleNextSync();
    }
  }

  void removeQueue() {
    Logger.log('Remove coins sync queue.');

    _stopQueue();
    _coinsRepository.removeSyncQueue();
  }

  void _stopQueue() {
    Logger.log('Stop coins sync queue.');

    _syncTimer?.cancel();
    _syncTimer = null;
    _isSyncQueueRunning = false;
  }

  Future<void> _scheduleNextSync() async {
    if (!_isSyncQueueRunning) return;

    final nextUpdate = await _coinsRepository.getNextSyncTime();
    if (nextUpdate == null) {
      Logger.log('Cannot schedule the next coins sync, because the next update date is null.');
      _stopQueue();
      return;
    }

    var delay = nextUpdate.difference(DateTime.now());
    // If delay is less or the same as threshold, increase delay manually
    if (delay <= _syncThreshold) {
      Logger.log(
        'Next coins sync time is in the past or now. Forcing delay to ${_syncThreshold.inSeconds} second.',
      );
      delay = _syncThreshold;
      nextUpdate.add(_syncThreshold);
    }

    Logger.log('Next coins sync scheduled at $nextUpdate, after $delay.');

    _syncTimer?.cancel();
    _syncTimer = Timer(delay, () async {
      await _syncCoins();

      if (_isSyncQueueRunning && (_syncTimer == null || !_syncTimer!.isActive)) {
        await _scheduleNextSync();
      } else {
        final reason =
            !_isSyncQueueRunning ? 'Sync queue was stopped.' : 'Sync timer is already active.';
        Logger.log('Skipping reschedule. $reason');
      }
    });
  }

  Future<void> _syncCoins() async {
    if (_syncInProgress) {
      Logger.log('Coins sync is already in progress. Skipping sync request.');
      return;
    }
    _syncInProgress = true;

    try {
      final coins = await _coinsRepository.getCoinsToSync(DateTime.now().add(_syncThreshold));

      Logger.log('Sync coins to get actual prices. Need to update ${coins.length} coins.');
      if (coins.isEmpty) return;

      final syncedCoinsData = await _ionIdentityClient.coins.syncCoins(
        coins.map((e) => e.symbolGroup).toSet(),
      );

      final syncedCoins = coins.map((coinDB) {
        final syncedData = syncedCoinsData.firstWhereOrNull(
          (e) => e.symbolGroup == coinDB.symbolGroup && e.network == coinDB.networkId,
        );

        if (syncedData == null) return coinDB;

        return coinDB.copyWith(
          priceUSD: syncedData.priceUSD,
          syncFrequency: syncedData.syncFrequency,
          decimals: syncedData.decimals,
        );
      }).toList();

      await _coinsRepository.updateCoins(syncedCoins);
      await _updateCoinsSyncQueue(
        syncedCoins.map((coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency)),
      );
    } catch (ex, stackTrace) {
      Logger.error(ex, stackTrace: stackTrace, message: 'Error during syncing coins.');
      _stopQueue();
    } finally {
      _syncInProgress = false;
      Logger.log('Coins sync finished.');
    }
  }

  Future<void> _updateCoinsSyncQueue(
    Iterable<({String coinId, Duration syncFrequency})> coins, {
    bool updateOnlyDifferences = false,
  }) async {
    final currentDate = DateTime.now();

    await _coinsRepository.updateCoinSyncQueue(
      coins.map(
        (coin) => (
          coinId: coin.coinId,
          syncAfter: currentDate.add(coin.syncFrequency),
        ),
      ),
      updateOnlyDifferences: updateOnlyDifferences,
    );
  }
}
