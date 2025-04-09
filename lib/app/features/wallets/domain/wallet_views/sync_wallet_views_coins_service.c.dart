import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_wallet_views_coins_service.c.g.dart';

@riverpod
Future<SyncWalletViewCoinsService> syncWalletViewCoinsService(Ref ref) async {
  return SyncWalletViewCoinsService(
    coinsRepository: ref.watch(coinsRepositoryProvider),
    ionIdentityClient: await ref.watch(ionIdentityClientProvider.future),
  );
}

// TODO: We need to stop/dispose this queue
class SyncWalletViewCoinsService {
  SyncWalletViewCoinsService({
    required CoinsRepository coinsRepository,
    required IONIdentityClient ionIdentityClient,
  })  : _coinsRepository = coinsRepository,
        _ionIdentityClient = ionIdentityClient;

  final CoinsRepository _coinsRepository;
  final IONIdentityClient _ionIdentityClient;

  var _syncQueueActive = false;
  var _syncQueueInitialized = false;

  Future<void> startCoinsSyncQueue(List<CoinData> coins) async {
    final coinIds = coins.map((coin) => coin.id).toSet();

    Future<bool> isQueueNotReady() async => !(await _coinsRepository.isSyncQueueReady(coinIds));

    if (await isQueueNotReady()) {
      // We need to be sure, that coins from the WalletView already in the DB,
      // so we wait to get them from there. This is the entry point to the queue,
      // so before we start the periodic sync, we need to make sure that it only contains the coins
      // that are in WalletViews. So if the isQueueIsNotReady returns false in the stream,
      // we tell the sync method to remove the coins that are not in WalletViews from the queue
      // and add new ones.
      final completer = Completer<void>();
      final subscription = _coinsRepository.watchCoins(coinIds).listen((coins) async {
        if (coins.isNotEmpty) {
          if (await isQueueNotReady()) {
            await _updateCoinsSyncQueue(
              coins.map(
                (coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency),
              ),
              updateOnlyDifferences: true,
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
      unawaited(syncCoins());
    }
  }

  void removeCoinsSyncQueue() {
    Logger.log('Remove coins sync queue');

    _stopCoinsSyncQueue();
    _coinsRepository.removeSyncQueue();
  }

  void _stopCoinsSyncQueue() {
    _syncQueueActive = false;
    _syncQueueInitialized = false;
  }

  Future<void> syncCoins() async {
    final nextUpdate = await _coinsRepository.getNextSyncTime();

    if (nextUpdate == null || !_syncQueueActive) {
      // There are no coins to sync or sync queue was disabled
      _stopCoinsSyncQueue();
      return;
    }

    _syncQueueInitialized = true;

    final difference = nextUpdate.difference(DateTime.now());
    Logger.log(
      'Coins sync queue is active. The next sync will be on the $nextUpdate',
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

      final syncedCoins = coins.map((coinDB) {
        final syncedData = syncedCoinsData.firstWhere((e) => e.symbolGroup == coinDB.symbolGroup);

        return coinDB.copyWith(
          priceUSD: syncedData.priceUSD,
          syncFrequency: syncedData.syncFrequency,
          decimals: syncedData.decimals,
        );
      }).toList();

      await _coinsRepository.updateCoins(syncedCoins);
      await _updateCoinsSyncQueue(
        syncedCoins.map(
          (coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency),
        ),
      );
    }

    // First section (coins with the same syncFrequency)
    // in the queue was updated, move on to the next syncFrequency group of coins
    unawaited(syncCoins());
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
