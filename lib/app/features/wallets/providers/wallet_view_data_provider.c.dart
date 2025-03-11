// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/update_user_metadata_notifier.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_view_id_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_view_data_provider.c.g.dart';

@Riverpod(keepAlive: true)
class WalletViewsDataNotifier extends _$WalletViewsDataNotifier {
  StreamSubscription<Iterable<CoinData>>? _subscription;

  @override
  Future<List<WalletViewData>> build() async {
    final walletViewsService = await ref.watch(walletViewsServiceProvider.future);

    final initialViews = await walletViewsService.fetch();
    unawaited(ref.read(updateUserMetadataNotifierProvider.notifier).updatePublishedWallets());

    await _listenForPriceUpdates(initialViews);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return initialViews;
  }

  Future<void> _listenForPriceUpdates(Iterable<WalletViewData> walletViews) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    final coinsService = await ref.read(coinsServiceProvider.future);

    final coinIds = walletViews
        .expand((view) => view.coinGroups)
        .expand((group) => group.coins)
        .map((coin) => coin.coin.id)
        .toSet();

    await _subscription?.cancel();
    _subscription = coinsService.watchCoins(coinIds).listen((updatedCoins) {
      state = state.map(
        data: (data) {
          final merged = [
            for (final walletView in data.value)
              walletViewsService.mergeWalletViewWithPriceUpdates(
                walletView,
                updatedCoins,
              ),
          ];
          return AsyncData(merged);
        },
        error: (error) => error,
        loading: (loading) => loading,
      );
    });
  }

  void refresh(WalletViewData walletView) {
    // Nothing to update, we have not loaded wallet views
    if (state.isLoading || state.hasError) return;

    final index = state.value?.indexWhere((w) => w.id == walletView.id);

    state = AsyncData(
      switch (index) {
        // Wallet views are not initialized
        null => state.value ?? [],
        // New wallet, add to list
        -1 => (state.value?.toList() ?? [])..add(walletView),
        // Update existed wallet view
        _ => () {
            final updatedState = state.value!.toList();
            updatedState[index] = walletView;
            return updatedState;
          }(),
      },
    );

    // Refresh subscription since coins list in wallets may have changed
    _refreshPriceUpdatesSubscription();
  }

  void _refreshPriceUpdatesSubscription() {
    if (state.value case final List<WalletViewData> wallets) {
      _listenForPriceUpdates(wallets);
    }
  }

  Future<void> create(String walletViewName) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    final result = await walletViewsService.create(walletViewName);
    refresh(result);
  }

  Future<void> delete(String walletViewId) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.delete(walletViewId: walletViewId);
    final wallets = state.value;
    if (wallets != null) {
      state = AsyncData(
        wallets..removeWhere((wallet) => wallet.id == walletViewId),
      );
    }

    // No need to listen price updates for coins from removed wallet
    _refreshPriceUpdatesSubscription();
  }

  Future<void> updateWalletView({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    final result = await walletViewsService.update(
      walletView: walletView,
      updatedName: updatedName,
      updatedCoinsList: updatedCoinsList,
    );
    refresh(result);
  }
}

@Riverpod(keepAlive: true)
Future<String> currentWalletViewId(Ref ref) async {
  final savedSelectedWalletId = ref.watch(selectedWalletViewIdNotifierProvider);
  final walletsData = await ref.watch(walletViewsDataNotifierProvider.future);

  final selectedWallet =
      walletsData.firstWhereOrNull((wallet) => wallet.id == savedSelectedWalletId);
  return selectedWallet?.id ?? walletsData.firstOrNull?.id ?? '';
}

@riverpod
Future<WalletViewData> currentWalletViewData(Ref ref) async {
  final currentWalletId = await ref.watch(currentWalletViewIdProvider.future);
  final walletsData = await ref.watch(walletViewsDataNotifierProvider.future);

  return walletsData.firstWhere((wallet) => wallet.id == currentWalletId);
}

@riverpod
Future<WalletViewData> walletViewById(Ref ref, {required String id}) async {
  final wallets = await ref.watch(walletViewsDataNotifierProvider.future);

  return wallets.firstWhere((wallet) => wallet.id == id);
}
