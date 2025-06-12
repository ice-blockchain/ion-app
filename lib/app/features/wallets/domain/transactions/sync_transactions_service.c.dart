// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/transaction_loader.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/transfer_status_updater.c.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_transactions_service.c.g.dart';

@Riverpod(keepAlive: true)
Future<SyncTransactionsService> syncTransactionsService(Ref ref) async {
  Logger.log('XXX: syncTransactionsService: initializing sync transactions service');

  Logger.log('XXX: syncTransactionsService: getting wallets');
  final wallets = await ref.watch(walletsNotifierProvider.future);
  Logger.log('XXX: syncTransactionsService: getting networks repo');
  final networks = ref.watch(networksRepositoryProvider);
  Logger.log('XXX: syncTransactionsService: getting crypto wallets repo');
  final cryptoWallets = ref.watch(cryptoWalletsRepositoryProvider);
  Logger.log('XXX: syncTransactionsService: getting transaction loader');
  final transactionLoader = await ref.watch(transactionLoaderProvider.future);
  Logger.log('XXX: syncTransactionsService: getting transfer status updater');
  final transferStatusUpdater = await ref.watch(transferStatusUpdaterProvider.future);
  Logger.log('XXX: syncTransactionsService: getting wallet views service');
  final walletViews = await ref.watch(walletViewsServiceProvider.future);

  try {
    Logger.log('XXX: syncTransactionsService: returning sync transactions service');
    return SyncTransactionsService(
      wallets,
      networks,
      cryptoWallets,
      transactionLoader,
      transferStatusUpdater,
      walletViews,
    );
  } catch (error, stackTrace) {
    Logger.error(
      error,
      stackTrace: stackTrace,
      message: 'XXX: syncTransactionsServiceProvider: failed',
    );
    rethrow;
  }
}

/// Loads the available wallet history, and on subsequent calls, synchronizes it.
/// For tier-2 network wallets, does the same, but for transfers.
/// In case of an error, logs it and skips the wallet.
class SyncTransactionsService {
  const SyncTransactionsService(
    this._userWallets,
    this._networksRepository,
    this._cryptoWalletsRepository,
    this._transactionLoader,
    this._transferStatusUpdater,
    this._walletViewsService,
  );

  final List<Wallet> _userWallets;
  final NetworksRepository _networksRepository;
  final CryptoWalletsRepository _cryptoWalletsRepository;
  final WalletViewsService _walletViewsService;

  final TransactionLoader _transactionLoader;
  final TransferStatusUpdater _transferStatusUpdater;

  Future<Map<String, WalletViewData>> _getWalletViews() async {
    final walletViews = _walletViewsService.lastEmitted.isNotEmpty
        ? _walletViewsService.lastEmitted
        : await _walletViewsService.walletViews.first;
    return walletViews.walletIdToWalletView();
  }

  Future<void> sync() async {
    final networks = await _networksRepository.getAllAsMap();
    final walletViews = await _getWalletViews();

    await _userWallets.map((wallet) async {
      final network = networks[wallet.network];
      final walletViewId = walletViews[wallet.id]?.id;

      final isHistoryLoaded =
          await _cryptoWalletsRepository.isHistoryLoadedForWallet(walletId: wallet.id);

      if (network == null) {
        Logger.error(
          'We are not support ${wallet.network} right now. '
          'Skip history sync for the wallet (id: ${wallet.id}, address: ${wallet.address}).',
        );
        return;
      }

      if (walletViewId == null) {
        Logger.info(
          'Wallet (id: ${wallet.id}, address: ${wallet.address}) is not connected to any existed wallet view. '
          'Skip history sync.',
        );
        return;
      }

      final success = network.isIonHistorySupported &&
          await _transactionLoader.load(
            wallet: wallet,
            walletViewId: walletViewId,
            isFullLoad: !isHistoryLoaded,
          );

      if (!success) {
        await _transferStatusUpdater.update(wallet);
      }

      if (!isHistoryLoaded) {
        await _cryptoWalletsRepository.save(wallet: wallet, isHistoryLoaded: true);
      }
    }).wait;
  }

  Future<void> syncBroadcastedTransfers() async {
    final walletViews = await _getWalletViews();

    await _userWallets.map((wallet) async {
      final isConnectedToWalletView = walletViews[wallet.id] != null;

      if (isConnectedToWalletView) {
        await _transferStatusUpdater.update(wallet);
      }
    }).wait;
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
