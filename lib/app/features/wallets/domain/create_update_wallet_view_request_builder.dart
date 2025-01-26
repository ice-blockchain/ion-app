part of 'wallet_views_service.c.dart';

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
      final List<CoinData> coins => _getRequestDataFromCoinsList(coins, userWallets!),
      null when walletView != null => _getRequestDataFromWalletView(walletView),
      _ => (const <String>{}, const <WalletViewCoinData>[]),
    };

    return CreateUpdateWalletViewRequest(
      items: items,
      symbolGroups: symbolGroups.toList(),
      name: name ?? walletView!.name,
    );
  }

  (Set<String>, List<WalletViewCoinData>) _getRequestDataFromWalletView(
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

  (Set<String>, List<WalletViewCoinData>) _getRequestDataFromCoinsList(
    List<CoinData> coins,
    List<Wallet> userWallets,
  ) {
    final symbolGroups = <String>{};
    final walletViewItems = <WalletViewCoinData>[];

    final networkWithWallet = {
      for (final wallet in userWallets) wallet.network.toLowerCase(): wallet,
    };

    for (final coin in coins) {
      final walletId = networkWithWallet[coin.network.toLowerCase()]?.id;
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
