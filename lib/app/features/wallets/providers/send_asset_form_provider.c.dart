// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/send_asset_form_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_asset_form_provider.c.g.dart';

enum CryptoAssetType { coin, nft }

@Riverpod(keepAlive: true)
class SendAssetFormController extends _$SendAssetFormController {
  @override
  SendAssetFormData build({CryptoAssetType type = CryptoAssetType.coin}) {
    final walletView = ref.watch(currentWalletViewDataProvider).requireValue;
    return SendAssetFormData(
      wallet: walletView,
      network: Network.ion,
      arrivalTime: 0,
      arrivalDateTime: DateTime.now(),
      address: '',
    );
  }

  void setNft(NftData nft) => state = state.copyWith(assetData: CryptoAssetData.nft(nft: nft));

  void setCoin(CoinsGroup coin) {
    final defaultCoin = coin.coins.first.coin;
    state = state.copyWith(
      network: defaultCoin.network,
      assetData: CryptoAssetData.coin(coin: coin),
    );
  }

  void setContact(String? pubkey) => state = state.copyWith(contactPubkey: pubkey);

  void setNetwork(Network network) {
    state = state.copyWith(network: network);
    _loadFeesInfo();
  }

  Future<void> _loadFeesInfo() async {
    final client = await ref.read(ionIdentityClientProvider.future);
    final result = await client.networks.getEstimateFees(network: state.network.serverName);
  }

  void setCoinsAmount(String amount) {
    final parsedAmount = double.tryParse(amount) ?? 0.0;

    if (state.assetData case final CoinAssetData coin) {
      final amount = switch (parsedAmount) {
        final double value when value <= 0.0 => 0.0,
        final double value when value > coin.maxAmount => coin.maxAmount,
        _ => parsedAmount,
      };
      state = state.copyWith(
        assetData: coin.copyWith(
          amount: amount,
        ),
      );
    }
  }

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);
}
