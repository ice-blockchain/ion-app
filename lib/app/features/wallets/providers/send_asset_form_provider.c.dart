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
  CryptoAssetData build({
    CryptoAssetType type = CryptoAssetType.coin,
    CoinsGroup? coin,
    NftData? nft,
  }) {
    assert(
      (type == CryptoAssetType.coin && coin != null) ||
          (type == CryptoAssetType.nft && nft != null),
      'Coin or NFT must be provided based on type',
    );

    final walletView = ref.watch(currentWalletViewDataProvider).requireValue;

    return CryptoAssetData(
      selectedNetwork: switch (type) {
        CryptoAssetType.coin => coin!.coins.first.coin.network,
        CryptoAssetType.nft => Network.ion // Not implemented
      },
      wallet: walletView,
      address: 'Not implemented',
      // TODO (1) not implemented
      arrivalTime: 15,
      arrivalDateTime: DateTime.now(),
      selectedCoin: coin,
      selectedNft: nft,
    );
  }

  void setNft(NftData nft) => state = state.copyWith(selectedNft: nft);

  void setCoin(CoinsGroup coin) => state = state.copyWith(selectedCoin: coin);

  void setContact(String? pubkey) =>
      state = state.copyWith(selectedContactPubkey: pubkey);

  void setNetwork(Network network) =>
      state = state.copyWith(selectedNetwork: network);

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
