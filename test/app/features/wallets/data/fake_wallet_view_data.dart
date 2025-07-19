// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/model/nft_data.f.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';

import 'fake_network_data.dart';

class FakeWalletViewData {
  static WalletViewData create({
    required String id,
    required String walletId,
    required String symbolGroup,
    String networkId = 'network1',
    String walletAddress = 'address1',
    String? name,
    double usdBalance = 0.0,
    int createdAt = 0,
    int updatedAt = 0,
    bool isMainWalletView = true,
  }) {
    return WalletViewData(
      id: id,
      name: name ?? '$symbolGroup Wallet View',
      coinGroups: [_createCoinsGroup(symbolGroup, walletId, walletAddress, networkId)],
      symbolGroups: {symbolGroup},
      nfts: const <NftData>[],
      usdBalance: usdBalance,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isMainWalletView: isMainWalletView,
    );
  }

  static CoinsGroup _createCoinsGroup(
    String symbolGroup,
    String walletId,
    String walletAddress,
    String networkId,
  ) {
    final coinData = CoinData(
      id: '$symbolGroup-coin',
      name: '$symbolGroup Coin',
      contractAddress: 'contract-$symbolGroup',
      decimals: 18,
      iconUrl: 'icon.png',
      abbreviation: symbolGroup,
      network: FakeNetworkData.create(
        id: networkId,
        isIonHistorySupported: networkId != 'network2',
      ),
      priceUSD: 0,
      symbolGroup: symbolGroup,
      syncFrequency: const Duration(hours: 1),
    );

    final coinInWallet = CoinInWalletData(
      coin: coinData,
      walletId: walletId,
      walletAddress: walletAddress,
    );

    return CoinsGroup(
      name: '$symbolGroup Group',
      iconUrl: 'icon.png',
      symbolGroup: symbolGroup,
      abbreviation: symbolGroup,
      coins: [coinInWallet],
    );
  }
}
