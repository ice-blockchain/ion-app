// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
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

  Future<List<WalletViewData>> get _walletViews async => _walletViewsService.lastEmitted.isNotEmpty
      ? _walletViewsService.lastEmitted
      : await _walletViewsService.walletViews.first;

  Future<void> sync() async {
    final networks = await _networksRepository.getAllAsMap();
    final walletViews = await _walletViews;

    await _userWallets.map((wallet) async {
      final network = networks[wallet.network];
      final walletViewId = walletViews.getWalletViewIdByWallet(wallet);

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
    final walletViews = await _walletViews;

    await _userWallets.map((wallet) async {
      final isConnectedToWalletView = walletViews.getWalletViewIdByWallet(wallet) != null;
      if (isConnectedToWalletView) {
        await _transferStatusUpdater.update(wallet);
      }
    }).wait;
  }
}

extension on List<WalletViewData> {
  String? getWalletViewIdByWallet(Wallet wallet) {
    return firstWhereOrNull(
      (wv) => wv.coins.firstWhereOrNull((coin) => coin.walletId == wallet.id) != null,
    )?.id;
  }
}
