// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/wallets/data/repository/crypto_wallets_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.r.dart';
import 'package:ion/app/features/wallets/domain/transactions/transaction_loader.r.dart';
import 'package:ion/app/features/wallets/domain/transactions/transfer_status_updater.r.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.r.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_transactions_service.r.g.dart';

@Riverpod(keepAlive: true)
Future<SyncTransactionsService> syncTransactionsService(Ref ref) async {
  return SyncTransactionsService(
    await ref.watch(walletsNotifierProvider.future),
    ref.watch(networksRepositoryProvider),
    await ref.watch(cryptoWalletsRepositoryProvider),
    await ref.watch(transactionLoaderProvider.future),
    await ref.watch(transferStatusUpdaterProvider.future),
    await ref.watch(walletViewsServiceProvider.future),
  );
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
