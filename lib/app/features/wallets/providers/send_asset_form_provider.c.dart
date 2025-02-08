// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_type.dart';
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

  void setNft(NftData nft) {
    // state = state.copyWith(assetData: CryptoAssetData.nft(nft: nft));
  }

  void setCoin(CoinsGroup coin) {
    final defaultCoin = coin.coins.first.coin;
    state = state.copyWith(
      network: defaultCoin.network,
      assetData: CryptoAssetData.coin(coinsGroup: coin),
    );
  }

  void setContact(String? pubkey) => state = state.copyWith(contactPubkey: pubkey);

  void setNetwork(Network network) {
    state = state.copyWith(network: network);

    if (state.assetData case final CoinAssetData coin) {
      state = state.copyWith(
        assetData: coin.copyWith(
          selectedOption: coin.coinsGroup.coins.firstWhere(
            (e) => e.coin.network == network,
          ),
        ),
      );
    }

    _loadFeesInfo();
  }

  Future<void> _loadFeesInfo() async {
    final client = await ref.read(ionIdentityClientProvider.future);
    final result = await client.networks.getEstimateFees(network: state.network.serverName);

    if (state.assetData case final CoinAssetData coin) {
      final walletId = coin.selectedOption?.walletId;
      if (walletId != null) {
        final asset = await client.wallets.getWalletAssets(walletId).then(
              (result) => result.assets.firstWhereOrNull((asset) => asset.isNative),
            );

        double calculateAmount(String maxFeePerGas) =>
            double.parse(maxFeePerGas) / pow(10, asset!.decimals);

        final options = [
          if (result.slow != null && asset != null)
            NetworkFeeOption(
              amount: calculateAmount(result.slow!.maxFeePerGas),
              symbol: asset.symbol,
              arrivalTime: result.slow?.waitTime,
              type: NetworkFeeType.slow,
            ),
          if (result.standard != null && asset != null)
            NetworkFeeOption(
              amount: calculateAmount(result.standard!.maxFeePerGas),
              symbol: asset.symbol,
              arrivalTime: result.standard?.waitTime,
              type: NetworkFeeType.standard,
            ),
          if (result.fast != null && asset != null)
            NetworkFeeOption(
              amount: calculateAmount(result.fast!.maxFeePerGas),
              symbol: asset.symbol,
              arrivalTime: result.fast?.waitTime,
              type: NetworkFeeType.fast,
            ),
        ];
        state = state.copyWith(
          networkFeeOptions: options,
          selectedNetworkFeeOption: options.firstOrNull,
        );
      }
    }
  }

  void setCoinsAmount(String amount) {
    if (state.assetData case final CoinAssetData coin) {
      final parsedAmount = double.tryParse(amount) ?? 0.0;
      state = state.copyWith(
        assetData: coin.copyWith(
          amount: parsedAmount,
        ),
      );
    }
  }

  void updateArrivalTime(int arrivalTime) => state = state.copyWith(arrivalTime: arrivalTime);

  void selectNetworkFeeOption(NetworkFeeOption selectedOption) {
    state = state.copyWith(
      selectedNetworkFeeOption: selectedOption,
    );
  }
}
