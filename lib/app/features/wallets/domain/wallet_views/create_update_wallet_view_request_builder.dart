// SPDX-License-Identifier: ice License 1.0

part of 'wallet_views_service.c.dart';

typedef _RequestParams = (Set<String>, List<WalletViewCoinData>);

class _CreateUpdateRequestBuilder {
  CreateUpdateWalletViewRequest build({
    String? name,
    WalletViewData? walletView,
    List<CoinData>? coinsList,
    List<Wallet>? userWallets,
  }) {
    if (name == null && walletView == null) {
      throw UpdateWalletViewRequestWithoutDataException();
    }

    if (coinsList != null && userWallets == null) {
      throw UpdateWalletViewRequestNoUserWalletsException();
    }

    final (symbolGroups, items) = switch (coinsList) {
      final List<CoinData> coins => _getRequestDataFromCoinsList(coins, userWallets!, walletView),
      null when walletView != null => _getRequestDataFromWalletView(walletView),
      _ => (const <String>{}, const <WalletViewCoinData>[]),
    };

    return CreateUpdateWalletViewRequest(
      items: items,
      symbolGroups: symbolGroups.toList(),
      name: name ?? walletView!.name,
    );
  }

  _RequestParams _getRequestDataFromWalletView(
    WalletViewData walletView,
  ) {
    final symbolGroups = <String>{};
    final walletViewItems = <WalletViewCoinData>[];

    for (final coinsGroup in walletView.coinGroups) {
      for (final coinInWallet in coinsGroup.coins) {
        final coin = coinInWallet.coin;
        symbolGroups.add(coin.symbolGroup);
        walletViewItems.add(
          WalletViewCoinData(
            coinId: coin.id,
            walletId: coinInWallet.walletId,
          ),
        );
      }
    }

    return (symbolGroups, walletViewItems);
  }

  _RequestParams _getRequestDataFromCoinsList(
    List<CoinData> coins,
    List<Wallet> userWallets,
    WalletViewData? walletView,
  ) {
    final symbolGroups = <String>{};
    final walletViewItems = <WalletViewCoinData>[];

    final networkWithWallet = <String, List<Wallet>>{};
    for (final wallet in userWallets) {
      final network = wallet.network.toLowerCase();
      networkWithWallet.putIfAbsent(network, () => []).add(wallet);
    }

    for (final coin in coins) {
      final wallets = networkWithWallet[coin.network.id.toLowerCase()];
      final walletId = wallets?.firstWhereOrNull((wallet) => wallet.name == walletView?.id)?.id;
      symbolGroups.add(coin.symbolGroup);
      walletViewItems.add(
        WalletViewCoinData(
          coinId: coin.id,
          walletId: walletId,
        ),
      );
    }

    return (symbolGroups, walletViewItems);
  }
}
