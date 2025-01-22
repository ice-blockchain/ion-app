// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/main_wallet_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_wallet_views_provider.c.g.dart';

@Riverpod(keepAlive: true)
class UserWalletViewsNotifier extends _$UserWalletViewsNotifier {
  String mainWalletId = '';

  @override
  Future<List<WalletViewData>> build() async {
    final identity = await ref.watch(ionIdentityClientProvider.future);
    mainWalletId = ref.watch(mainWalletProvider).value?.id ?? mainWalletId;

    final shortViews = await identity.wallets.getWalletViews();
    final viewsDetailsDTO = await Future.wait(
      shortViews.map((e) => identity.wallets.getWalletView(e.id)),
    );

    return viewsDetailsDTO.map(_parseWalletView).toList();
  }

  WalletViewData _parseWalletView(WalletView viewDTO) {
    final coins = <CoinInWalletData>[];
    final symbolGroups = <String>{};

    var totalViewBalanceUSD = 0.0;
    var isMainWalletView = false;

    for (final coinInWalletDTO in viewDTO.coins) {
      final coinDTO = coinInWalletDTO.coin;
      final aggregationItem = viewDTO.aggregation[coinDTO.symbol];

      var coinAmount = 0.0;
      var coinBalanceUSD = 0.0;
      String? network;

      if (coinInWalletDTO.walletId == mainWalletId) {
        isMainWalletView = true;
      }

      if (aggregationItem != null) {
        final wallet = aggregationItem.wallets
            .firstWhereOrNull((wallet) => wallet.walletId == coinInWalletDTO.walletId);
        final asset = wallet?.asset;
        network = wallet?.network;

        if (asset != null) {
          coinAmount = double.tryParse(asset.balance) ?? 0;
          coinBalanceUSD = (coinAmount / pow(10, coinDTO.decimals)) * coinDTO.priceUSD;
        }
      }

      totalViewBalanceUSD += coinBalanceUSD;
      symbolGroups.add(coinDTO.symbolGroup);
      coins.add(
        CoinInWalletData(
          amount: coinAmount,
          balanceUSD: coinBalanceUSD,
          walletId: coinInWalletDTO.walletId,
          network: network,
          coin: CoinData.fromDTO(coinDTO),
        ),
      );
    }

    return WalletViewData(
      coins: coins,
      id: viewDTO.id,
      name: viewDTO.name,
      symbolGroups: symbolGroups,
      createdAt: viewDTO.createdAt,
      updatedAt: viewDTO.updatedAt,
      usdBalance: totalViewBalanceUSD,
      isMainWalletView: isMainWalletView,
    );
  }

  Future<void> refreshWalletView(ShortWalletView walletView) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final identity = await ref.read(ionIdentityClientProvider.future);

      final viewDTO = await identity.wallets.getWalletView(walletView.id);
      final updatedWalletView = _parseWalletView(viewDTO);
      final index = state.value?.indexWhere((walletView) => walletView.id == updatedWalletView.id);

      if (index == null) {
        // Wallet views are not initialized
        return state.value ?? [];
      }

      if (index == -1) {
        // New wallet, add to list
        return (state.value?.toList() ?? [])..add(updatedWalletView);
      }

      print('Denis: wallet view was updated');

      // Update existed wallet
      final updatedState = state.value!.toList();
      updatedState[index] = updatedWalletView;
      return updatedState;
    });
  }

  void delete(String walletViewId) {
    final wallets = state.value;
    if (wallets != null) {
      state = AsyncData(
        wallets..removeWhere((wallet) => wallet.id == walletViewId),
      );
    }
  }
}
