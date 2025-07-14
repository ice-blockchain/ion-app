// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/transactions/transaction_loader.r.dart';
import 'package:ion/app/features/wallets/domain/transactions/transfer_status_updater.r.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.r.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_transactions_service.r.g.dart';

typedef _NetworkId = String;
typedef _CryptoWalletId = String;

/// Objects container for sync operations
class _SyncObjects {
  const _SyncObjects({
    required this.networks,
    required this.walletViews,
  });

  final Map<_NetworkId, NetworkData> networks;
  final Map<_CryptoWalletId, WalletViewData> walletViews;
}

@Riverpod(keepAlive: true)
Future<SyncTransactionsService> syncTransactionsService(Ref ref) async {
  return SyncTransactionsService(
    await ref.watch(walletsNotifierProvider.future),
    ref.watch(networksRepositoryProvider),
    await ref.watch(cryptoWalletsRepositoryProvider),
    await ref.watch(transactionLoaderProvider.future),
    await ref.watch(transferStatusUpdaterProvider.future),
    await ref.watch(walletViewsServiceProvider.future),
    await ref.watch(transactionsRepositoryProvider.future),
  );
}

/// Loads the available wallet history, and on subsequent calls, synchronizes it.
/// For tier-2 network wallets, does the same, but for transfers.
/// In case of an error, logs it and skips the wallet.
class SyncTransactionsService {
  SyncTransactionsService(
    this._userWallets,
    this._networksRepository,
    this._cryptoWalletsRepository,
    this._transactionLoader,
    this._transferStatusUpdater,
    this._walletViewsService,
    this._transactionsRepository,
  );

  final List<Wallet> _userWallets;
  final NetworksRepository _networksRepository;
  final CryptoWalletsRepository _cryptoWalletsRepository;
  final WalletViewsService _walletViewsService;
  final TransactionsRepository _transactionsRepository;

  final TransactionLoader _transactionLoader;
  final TransferStatusUpdater _transferStatusUpdater;

  // Cache for networks data
  Map<String, NetworkData>? _cachedNetworks;

  Future<void> syncAll() async {
    final syncObjects = await _prepareSyncObjects();

    await _userWallets.map((wallet) async {
      final isHistoryLoaded =
          await _cryptoWalletsRepository.isHistoryLoadedForWallet(walletId: wallet.id);

      await _syncWallet(
        wallet: wallet,
        syncObjects: syncObjects,
        isFullLoad: !isHistoryLoaded,
        updateHistoryLoaded: true,
      );
    }).wait;
  }

  Future<void> syncBroadcastedTransfers() async {
    final syncObjects = await _prepareSyncObjects();
    final walletsToSync = await _getWalletsWithBroadcastedTransfers();

    if (walletsToSync.isEmpty) {
      Logger.info('No broadcasted transfers found, skipping sync');
      print('[${DateTime.now().toString().substring(11, 23)}] No broadcasted transfers found, skipping sync');
      return;
    }

    _logWalletSync('Syncing wallets with broadcasted transfers', walletsToSync, syncObjects);

    await _syncWallets(
      wallets: walletsToSync,
      syncObjects: syncObjects,
      isFullLoad: false,
      updateHistoryLoaded: false,
    );

    Logger.info('Completed syncing wallets with broadcasted transfers');
    print('[${DateTime.now().toString().substring(11, 23)}] Completed syncing wallets with broadcasted transfers');
  }

  /// Gets wallets that have broadcasted transfers
  Future<List<Wallet>> _getWalletsWithBroadcastedTransfers() async {
    final broadcastedTransfers = await _transactionsRepository.getBroadcastedTransfers();

    if (broadcastedTransfers.isEmpty) return [];

    final walletsWithBroadcastedTransfers =
        broadcastedTransfers.map((tx) => tx.senderWalletAddress).whereType<String>().toSet();

    return _userWallets
        .where((wallet) => walletsWithBroadcastedTransfers.contains(wallet.address))
        .toList();
  }

  /// Syncs transactions for a specific coin across all networks/wallets
  Future<void> syncForCoin(String symbolGroup) async {
    final syncObjects = await _prepareSyncObjects();
    final walletsWithCoin = _getWalletsWithCoin(symbolGroup, syncObjects);

    if (walletsWithCoin.isEmpty) {
      Logger.info('No wallets found with coin symbolGroup: $symbolGroup');
      print('[${DateTime.now().toString().substring(11, 23)}] No wallets found with coin symbolGroup: $symbolGroup');
      return;
    }

    _logWalletSync('Syncing coin $symbolGroup', walletsWithCoin, syncObjects);

    await _syncWallets(
      wallets: walletsWithCoin,
      syncObjects: syncObjects,
      isFullLoad: false,
      updateHistoryLoaded: false,
    );

    Logger.info('Completed syncing coin $symbolGroup across all networks');
    print('[${DateTime.now().toString().substring(11, 23)}] Completed syncing coin $symbolGroup across all networks');
  }

  List<Wallet> _getWalletsWithCoin(String symbolGroup, _SyncObjects context) {
    return _userWallets.where((wallet) {
      final walletView = context.walletViews[wallet.id];
      if (walletView == null) return false;

      return walletView.coinGroups.any((group) => group.symbolGroup == symbolGroup);
    }).toList();
  }

  void _logWalletSync(String operation, List<Wallet> wallets, _SyncObjects syncObjects) {
    final message = '$operation across ${wallets.length} wallets: '
        '${wallets.map((w) => '${w.address}(${syncObjects.networks[w.network]?.id ?? w.network})').join(', ')}';
    Logger.info(message);
    print('[${DateTime.now().toString().substring(11, 23)}] $message');
  }

  /// Syncs multiple wallets with the same configuration
  Future<void> _syncWallets({
    required List<Wallet> wallets,
    required _SyncObjects syncObjects,
    required bool isFullLoad,
    required bool updateHistoryLoaded,
  }) async {
    await wallets.map((wallet) async {
      await _syncWallet(
        wallet: wallet,
        syncObjects: syncObjects,
        isFullLoad: isFullLoad,
        updateHistoryLoaded: updateHistoryLoaded,
      );
    }).wait;
  }

  /// Syncs a specific wallet with the blockchain
  Future<void> _syncWallet({
    required Wallet wallet,
    required _SyncObjects syncObjects,
    required bool isFullLoad,
    required bool updateHistoryLoaded,
  }) async {
    final network = syncObjects.networks[wallet.network];
    final walletViewId = syncObjects.walletViews[wallet.id]?.id;

    if (network == null) {
      final errorMessage = 'We are not support ${wallet.network} right now. '
          'Skip history sync for the wallet (id: ${wallet.id}, address: ${wallet.address}).';
      Logger.error(errorMessage);
      print('[${DateTime.now().toString().substring(11, 23)}] $errorMessage');
      return;
    }

    if (walletViewId == null) {
      final infoMessage = 'Wallet (id: ${wallet.id}, address: ${wallet.address}) is not connected to any existed wallet view. '
          'Skip history sync.';
      Logger.info(infoMessage);
      print('[${DateTime.now().toString().substring(11, 23)}] $infoMessage');
      return;
    }

    final success = network.isIonHistorySupported &&
        await _transactionLoader.load(
          wallet: wallet,
          walletViewId: walletViewId,
          isFullLoad: isFullLoad,
        );

    if (!success) {
      await _transferStatusUpdater.update(wallet);
    }

    if (updateHistoryLoaded && isFullLoad) {
      await _cryptoWalletsRepository.save(wallet: wallet, isHistoryLoaded: true);
    }
  }

  /// Prepares objects to sync wallets
  Future<_SyncObjects> _prepareSyncObjects() async {
    final networks = _cachedNetworks ??= await _networksRepository.getAllAsMap();
    final walletViews = _walletViewsService.lastEmitted.isNotEmpty
        ? _walletViewsService.lastEmitted
        : await _walletViewsService.walletViews.first;

    return _SyncObjects(
      networks: networks,
      walletViews: walletViews.walletIdToWalletView(),
    );
  }
}

extension on List<WalletViewData> {
  /// Returns a map of wallet IDs to the wallet views, that contains the wallet.
  Map<String, WalletViewData> walletIdToWalletView() {
    final walletIdToWalletView = <String, WalletViewData>{};

    for (final walletView in this) {
      for (final coin in walletView.coins) {
        if (coin.walletId case final String walletId) {
          walletIdToWalletView[walletId] = walletView;
        }
      }
    }

    return walletIdToWalletView;
  }
}
