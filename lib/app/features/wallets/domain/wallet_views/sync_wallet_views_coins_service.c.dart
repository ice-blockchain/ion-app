// SPDX-License-Identifier: ice License 1.0

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

class SyncWalletViewCoinsService {
  SyncWalletViewCoinsService({
    required CoinsRepository coinsRepository,
    required IONIdentityClient ionIdentityClient,
  })  : _coinsRepository = coinsRepository,
        _ionIdentityClient = ionIdentityClient;

  final CoinsRepository _coinsRepository;
  final IONIdentityClient _ionIdentityClient;

  Timer? _syncTimer;
  StreamSubscription<List<CoinData>>? _subscription;

  Future<void> start(List<CoinData> coins) async {
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

      await _subscription?.cancel();
      _subscription = _coinsRepository.watchCoins(coinIds).listen((coins) async {
        if (coins.isNotEmpty) {
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
          completer.complete();
        }
      });

      await completer.future;
      await _subscription?.cancel();
    }

    await _scheduleNextSync();
  }

  void removeQueue() {
    Logger.log('Remove coins sync queue.');

    _stopQueue();
    _subscription?.cancel();
    _coinsRepository.removeSyncQueue();
  }

  void _stopQueue() {
    Logger.log('Stop coins sync queue.');

    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> _scheduleNextSync() async {
    final nextUpdate = await _coinsRepository.getNextSyncTime();
    if (nextUpdate == null) {
      Logger.log('Cannot schedule the next coins sync, because the next update date is null');
      _stopQueue();
      return;
    }

    final delay = nextUpdate.difference(DateTime.now());

    Logger.log('Next coins sync scheduled at $nextUpdate.');

    _syncTimer?.cancel();
    _syncTimer = Timer(delay > Duration.zero ? delay : Duration.zero, () async {
      await _syncCoins();
      await _scheduleNextSync();
    });
  }

  Future<void> _syncCoins() async {
    final coins = await _coinsRepository.getCoinsToSync(DateTime.now());

    Logger.log('Sync coins to get actual prices. Need to update ${coins.length} coins.');
    if (coins.isEmpty) return;

    final syncedCoinsData = await _ionIdentityClient.coins.syncCoins(
      coins.map((e) => e.symbolGroup).toSet(),
    );

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
      syncedCoins.map((coin) => (coinId: coin.id, syncFrequency: coin.syncFrequency)),
    );
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
