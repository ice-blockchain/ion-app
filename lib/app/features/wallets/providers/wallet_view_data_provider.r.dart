// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.r.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_view_id_provider.r.dart';
import 'package:ion/app/features/wallets/providers/wallets_initializer_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_view_data_provider.r.g.dart';

@Riverpod(keepAlive: true)
class WalletViewsDataNotifier extends _$WalletViewsDataNotifier {
  StreamSubscription<List<WalletViewData>>? _subscription;
  StreamSubscription<List<TransactionData>>? _broadcastedTransfersSubscription;
  final Map<String, Set<String>> _walletViewTransactions = {};

  @override
  Future<List<WalletViewData>> build() async {
    // Wait until all preparations are completed
    await ref.watch(walletsInitializerNotifierProvider.future);

    final walletViewsService = await ref.watch(walletViewsServiceProvider.future);

    final walletViews = await walletViewsService.fetch();
    walletViewsService.walletViews.listen((walletViews) {
      state = AsyncData(walletViews);
    });

    await _setupBroadcastedTransfersListener(walletViews);

    ref.onDispose(() {
      _subscription?.cancel();
      _broadcastedTransfersSubscription?.cancel();
    });

    return walletViews;
  }

  Future<void> _setupBroadcastedTransfersListener(List<WalletViewData> walletViews) async {
    await _broadcastedTransfersSubscription?.cancel();

    if (walletViews.isEmpty) {
      return;
    }

    final walletViewIds = walletViews.map((view) => view.id).toList();

    final transactionsRepository = await ref.read(transactionsRepositoryProvider.future);

    Logger.info(
      '[UNIFIED_TX_DEBUG] Setting up unified transaction listener | '
      'WalletViews: ${walletViewIds.length} | '
      'Query: type=SEND, statuses=IN_PROGRESS | '
      'Watches: BOTH coins and NFTs',
    );

    _broadcastedTransfersSubscription = transactionsRepository
        .watchTransactions(
      type: TransactionType.send,
      walletViewIds: walletViewIds,
      statuses: TransactionStatus.inProgressStatuses,
    )
        .listen((List<TransactionData> currentTransactions) async {
      Logger.info(
        '[UNIFIED_TX_DEBUG] ✅ Unified Transaction Results | '
        'Found: ${currentTransactions.length} in-progress send transactions | '
        'Type: SEND | Status: IN_PROGRESS',
      );

      // Log breakdown by asset type
      final coinTxs = currentTransactions
          .where(
            (tx) => tx.cryptoAsset.when(
              coin: (_, __, ___, ____, _____) => true,
              nft: (_) => false,
              nftIdentifier: (_, __) => false,
            ),
          )
          .length;
      final nftTxs = currentTransactions.length - coinTxs;

      Logger.info(
        '[UNIFIED_TX_DEBUG] Transaction breakdown | '
        'Coins: $coinTxs | NFTs: $nftTxs | Total: ${currentTransactions.length}',
      );

      // Group transactions by wallet view ID
      final currentTransactionsByWalletView = <String, Set<String>>{};
      for (final transaction in currentTransactions) {
        currentTransactionsByWalletView
            .putIfAbsent(transaction.walletViewId, () => <String>{})
            .add(transaction.txHash);
      }

      final affectedWalletViewIds = <String>{};
      for (final walletViewId in walletViewIds) {
        final currentTxs = currentTransactionsByWalletView[walletViewId] ?? <String>{};
        final cachedTxs = _walletViewTransactions[walletViewId] ?? <String>{};

        if (!const SetEquality<String>().equals(currentTxs, cachedTxs)) {
          affectedWalletViewIds.add(walletViewId);
          _walletViewTransactions[walletViewId] = currentTxs;
        }
      }

      if (affectedWalletViewIds.isNotEmpty) {
        Logger.info(
          '[UNIFIED_TX_DEBUG] 🔄 Triggering wallet view refresh | '
          'Affected: ${affectedWalletViewIds.length} wallet views | '
          'WalletViewIds: [${affectedWalletViewIds.join(', ')}] | '
          'Reason: Transaction list changed',
        );

        final walletViewsService = await ref.read(walletViewsServiceProvider.future);
        for (final walletViewId in affectedWalletViewIds) {
          Logger.info('[UNIFIED_TX_DEBUG] Refreshing wallet view: $walletViewId');
          await walletViewsService.refresh(walletViewId);
        }

        Logger.info('[UNIFIED_TX_DEBUG] ✅ All affected wallet views refreshed');
      }
    });
  }

  Future<void> create(String walletViewName) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.create(walletViewName);
  }

  Future<void> delete(String walletViewId) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.delete(walletViewId: walletViewId);
  }

  Future<void> updateWalletView({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.update(
      walletView: walletView,
      updatedName: updatedName,
      updatedCoinsList: updatedCoinsList,
    );
  }
}

@riverpod
Future<String> currentWalletViewId(Ref ref) async {
  final currentWalletViewData = await ref.watch(currentWalletViewDataProvider.future);
  return currentWalletViewData.id;
}

@Riverpod(keepAlive: true)
Future<WalletViewData> currentWalletViewData(Ref ref) async {
  final savedSelectedWalletId = ref.watch(selectedWalletViewIdNotifierProvider);
  final walletsData = await ref.watch(walletViewsDataNotifierProvider.future);

  final selectedWallet =
      walletsData.firstWhereOrNull((wallet) => wallet.id == savedSelectedWalletId);
  return selectedWallet ?? walletsData.first;
}

@riverpod
Future<WalletViewData> walletViewById(Ref ref, {required String id}) async {
  final wallets = await ref.watch(walletViewsDataNotifierProvider.future);

  return wallets.firstWhere((wallet) => wallet.id == id);
}

@riverpod
Future<WalletViewData?> walletViewByAddress(
  Ref ref,
  String address,
) async {
  final wallets = await ref.watch(walletsNotifierProvider.future);
  final wallet = wallets.firstWhereOrNull((wallet) => wallet.address == address);

  if (wallet == null) {
    return null;
  }

  final walletViews = await ref.watch(walletViewsDataNotifierProvider.future);

  return walletViews.firstWhereOrNull(
    (walletView) => walletView.coins.any((coin) => coin.walletId == wallet.id),
  );
}
