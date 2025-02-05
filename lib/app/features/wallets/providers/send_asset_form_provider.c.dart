// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_asset_form_provider.c.g.dart';

enum CryptoAssetType { coin, nft }

@Riverpod(keepAlive: true)
class SendAssetFormController extends _$SendAssetFormController {
  // TODO: make async
  @override
  CryptoAssetData build({CryptoAssetType type = CryptoAssetType.coin}) {
    final walletView = ref.watch(currentWalletViewDataProvider).requireValue;
    return CryptoAssetData(
      wallet: walletView,
      // TODO: What to do with next values?
      arrivalTime: 0,
      arrivalDateTime: DateTime.now(),
      network: Network.ion,
      address: '',
    );
  }

  void setNft(NftData nft) => state = state.copyWith(nft: nft);

  void setCoin(CoinsGroup coin) {
    final defaultCoin = coin.coins.first.coin;

    state = state.copyWith(
      coin: coin,
      network: defaultCoin.network,
    );
  }

  void setContact(String? pubkey) =>
      state = state.copyWith(contactPubkey: pubkey);

  void setNetwork(Network network) => state = state.copyWith(network: network);

  void updateAmount(String amount) {
    // TODO: Not implemented
    // final value = double.tryParse(amount) ?? 0.0;
    // state = state.copyWith(
    //   selectedCoin: state.selectedCoin?.copyWith(
    //     amount: value,
    //   ),
    // );
  }

  void updateArrivalTime(int arrivalTime) =>
      state = state.copyWith(arrivalTime: arrivalTime);
}
