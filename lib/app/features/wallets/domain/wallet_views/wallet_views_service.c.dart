// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_update_wallet_view_request_builder.dart';
part 'wallet_views_service.c.g.dart';

@riverpod
Future<WalletViewsService> walletViewsService(Ref ref) async {
  return WalletViewsService(
    await ref.watch(ionIdentityClientProvider.future),
    await ref.watch(walletsNotifierProvider.future),
    await ref.watch(mainWalletProvider.future),
  );
}

class WalletViewsService {
  WalletViewsService(
    this._identity,
    this._userWallets,
    this._mainWallet,
  );

  final IONIdentityClient _identity;
  final Wallet _mainWallet;
  final List<Wallet> _userWallets;

  Future<List<WalletViewData>> fetch() async {
    final shortViews = await _identity.wallets.getWalletViews();
    final viewsDetailsDTO = await Future.wait(
      shortViews.map((e) => _identity.wallets.getWalletView(e.id)),
    );
    return viewsDetailsDTO.map(_parseWalletView).toList();
  }

  Future<WalletViewData> create(String name) async {
    final request = _CreateUpdateRequestBuilder().build(name: name);
    final walletView = await _identity.wallets.createWalletView(request).then(_parseWalletView);
    return walletView;
  }

  Future<WalletViewData> update({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    final request = _CreateUpdateRequestBuilder().build(
      name: updatedName,
      walletView: walletView,
      coinsList: updatedCoinsList,
      userWallets: _userWallets,
    );

    return _identity.wallets.updateWalletView(walletView.id, request).then(_parseWalletView);
  }

  Future<void> delete({required String walletViewId}) async {
    return _identity.wallets.deleteWalletView(walletViewId);
  }

  WalletViewData _parseWalletView(WalletView viewDTO) {
    final coinGroups = <String, CoinsGroup>{};
    final symbolGroups = <String>{};

    var totalViewBalanceUSD = 0.0;
    var isMainWalletView = false;

    for (final coinInWalletDTO in viewDTO.coins) {
      final coinDTO = coinInWalletDTO.coin;

      var coinAmount = 0.0;
      var coinBalanceUSD = 0.0;

      if (coinInWalletDTO.walletId == _mainWallet.id) {
        isMainWalletView = true;
      }

      final aggregationItem = _searchAggregationItem(
        coinInWalletDTO: coinInWalletDTO,
        aggregation: viewDTO.aggregation,
      );

      if (aggregationItem != null) {
        final asset = aggregationItem.wallets
            .firstWhereOrNull(
              (wallet) => wallet.walletId == coinInWalletDTO.walletId,
            )
            ?.asset;

        if (asset != null) {
          late final double assetBalance;
          try {
            assetBalance = double.parse(asset.balance);
          } on FormatException catch (_) {
            Logger.error('Failed to parse asset balance with `${asset.balance}` value.');
            assetBalance = 0;
          }

          coinAmount = assetBalance / pow(10, coinDTO.decimals);
          coinBalanceUSD = coinAmount * coinDTO.priceUSD;
        }
      }

      totalViewBalanceUSD += coinBalanceUSD;
      final symbolGroup = coinDTO.symbolGroup;
      symbolGroups.add(symbolGroup);

      final coinInWallet = CoinInWalletData(
        amount: coinAmount,
        balanceUSD: coinBalanceUSD,
        walletId: coinInWalletDTO.walletId,
        coin: CoinData.fromDTO(coinDTO),
      );

      final currentGroup = coinGroups[symbolGroup] ?? CoinsGroup.fromCoin(coinInWallet.coin);
      coinGroups[symbolGroup] = currentGroup.copyWith(
        totalAmount: currentGroup.totalAmount + coinInWallet.amount,
        totalBalanceUSD: currentGroup.totalBalanceUSD + coinInWallet.balanceUSD,
        coins: [
          ...currentGroup.coins,
          coinInWallet,
        ],
      );
    }

    return WalletViewData(
      coinGroups: coinGroups.values.toList()..sort(CoinsComparator().compareGroups),
      id: viewDTO.id,
      name: viewDTO.name,
      symbolGroups: symbolGroups,
      createdAt: viewDTO.createdAt,
      updatedAt: viewDTO.updatedAt,
      usdBalance: totalViewBalanceUSD,
      isMainWalletView: isMainWalletView,
    );
  }

  WalletViewAggregationItem? _searchAggregationItem({
    required CoinInWallet coinInWalletDTO,
    required Map<String, WalletViewAggregationItem> aggregation,
  }) {
    WalletViewAggregationItem? search(Iterable<WalletViewAggregationItem> searchSample) {
      for (final aggregation in aggregation.values) {
        final associatedWallet = aggregation.wallets.firstWhereOrNull(
          (e) => e.walletId == coinInWalletDTO.walletId && e.coinId == coinInWalletDTO.coin.id,
        );
        if (associatedWallet != null &&
            associatedWallet.network.toLowerCase() == coinInWalletDTO.coin.network.toLowerCase()) {
          return aggregation;
        }
      }
      return null;
    }

    // Return aggregation item if aggregation map contains coin symbol as a key
    // with the same wallet and coin ids as in CoinInWallet
    final symbol = coinInWalletDTO.coin.symbol;
    if (aggregation[symbol] case final WalletViewAggregationItem aggregation) {
      final result = search([aggregation]);
      if (result != null) return result;
    }

    // Attempt to find an aggregation item by indirect signs.
    // The search is performed on all aggregation items with a check
    // for matching the wallet ID, network, and coinId.
    return search(aggregation.values);
  }

  WalletViewData mergeWalletViewWithPriceUpdates(
    WalletViewData walletView,
    Iterable<CoinData> updatedCoins,
  ) {
    final updatedCoinGroups = walletView.coinGroups.map((group) {
      final updatedCoinsInGroup = group.coins.map((coinInWallet) {
        final updatedCoin = updatedCoins.firstWhereOrNull(
          (coin) => coin.id == coinInWallet.coin.id,
        );

        if (updatedCoin != null) {
          final updatedBalanceUSD = coinInWallet.amount * updatedCoin.priceUSD;

          return coinInWallet.copyWith(
            coin: updatedCoin,
            balanceUSD: updatedBalanceUSD,
          );
        }

        return coinInWallet;
      }).toList();

      return group.copyWith(
        coins: updatedCoinsInGroup,
        totalBalanceUSD: updatedCoinsInGroup.fold(
          0,
          (sum, coin) => sum + coin.balanceUSD,
        ),
        totalAmount: updatedCoinsInGroup.fold(
          0,
          (sum, coin) => sum + coin.amount,
        ),
      );
    }).toList();

    return walletView.copyWith(
      coinGroups: updatedCoinGroups,
      usdBalance: updatedCoinGroups.fold(
        0,
        (sum, group) => sum + group.totalBalanceUSD,
      ),
    );
  }
}
