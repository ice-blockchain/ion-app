// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_type.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/send_asset_form_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
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
      arrivalDateTime: DateTime.now(),
      receiverAddress: '',
    );
  }

  void setNft(NftData nft) {
    // TODO: Not implemented
    // state = state.copyWith(assetData: CryptoAssetData.nft(nft: nft));
  }

  void setCoin(CoinsGroup coin) {
    final defaultCoin = coin.coins.first.coin;
    state = state.copyWith(
      assetData: CryptoAssetData.coin(coinsGroup: coin),
    );
    setNetwork(defaultCoin.network);
  }

  void setContact(String? pubkey) => state = state.copyWith(contactPubkey: pubkey);

  Future<void> setNetwork(Network network) async {
    final wallets = await ref.read(walletsNotifierProvider.future);
    final wallet = wallets.firstWhereOrNull(
      (wallet) => wallet.network.toLowerCase() == network.serverName.toLowerCase(),
    );

    state = state.copyWith(
      network: network,
      senderWallet: wallet,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );

    if (state.assetData case final CoinAssetData coin) {
      state = state.copyWith(
        assetData: coin.copyWith(
          selectedOption: coin.coinsGroup.coins.firstWhere(
            (e) => e.coin.network == network,
          ),
        ),
      );
    }

    await _loadFeesInfo();
  }

  Future<void> _loadFeesInfo() async {
    final client = await ref.read(ionIdentityClientProvider.future);
    final result = await client.networks.getEstimateFees(network: state.network.serverName);

    if (state.assetData case final CoinAssetData coin) {
      final walletId = coin.selectedOption?.walletId;
      if (walletId != null) {
        final networkNativeToken = await client.wallets.getWalletAssets(walletId).then(
              (result) => result.assets.firstWhereOrNull((asset) => asset.isNative),
            );

        if (networkNativeToken case final WalletAsset asset) {
          final nativeCoin = await _getNativeCoin(asset);

          if (nativeCoin == null) return; // TODO: RETEST!

          final options = [
            if (result.slow != null)
              _buildNetworkFeeOption(
                result.slow!,
                NetworkFeeType.slow,
                nativeCoin,
                networkNativeToken,
              ),
            if (result.standard != null)
              _buildNetworkFeeOption(
                result.standard!,
                NetworkFeeType.standard,
                nativeCoin,
                networkNativeToken,
              ),
            if (result.fast != null)
              _buildNetworkFeeOption(
                result.fast!,
                NetworkFeeType.fast,
                nativeCoin,
                networkNativeToken,
              ),
          ];

          state = state.copyWith(
            networkFeeOptions: options,
            selectedNetworkFeeOption: options.firstOrNull,
            networkNativeToken: networkNativeToken.copyWith(
              name: networkNativeToken.name ?? nativeCoin.name,
            ),
          );

          _checkIfUserCanCoverFee();
        }
      }
    }
  }

  NetworkFeeOption _buildNetworkFeeOption(
    NetworkFee fee,
    NetworkFeeType type,
    CoinData nativeCoin,
    WalletAsset networkNativeToken,
  ) {
    double calculateAmount(String maxFeePerGas) =>
        double.parse(maxFeePerGas) / pow(10, networkNativeToken.decimals);
    double calculatePriceUSD(double amount) => amount * nativeCoin.priceUSD;

    final amount = calculateAmount(fee.maxFeePerGas);
    return NetworkFeeOption(
      amount: amount,
      priceUSD: calculatePriceUSD(amount),
      symbol: networkNativeToken.symbol,
      arrivalTime: fee.waitTime,
      type: type,
    );
  }

  Future<CoinData?> _getNativeCoin(WalletAsset asset) async {
    final service = await ref.read(coinsServiceProvider.future);

    var nativeCoin = await service
        .getCoinsByFilters(symbol: asset.symbol, network: state.network)
        .then((coins) => coins.firstOrNull);

    if (nativeCoin != null) return nativeCoin;

    // TODO: REMOVE STUB
    final coins = await service
        // .getCoinsByFilters(symbol: 'ETH', network: state.network)
        .getCoinsByFilters(network: state.network, contractAddress: '');
    nativeCoin = coins.firstOrNull;
    return nativeCoin;
  }

  void _checkIfUserCanCoverFee() {
    final selectedFee = state.selectedNetworkFeeOption;
    final networkNativeToken = state.networkNativeToken;

    if (selectedFee == null || networkNativeToken == null) return;

    final parsedBalance = double.tryParse(networkNativeToken.balance) ?? 0;
    final convertedBalance = parsedBalance / pow(10, networkNativeToken.decimals);
    final hasEnoughForFee = convertedBalance >= selectedFee.amount;

    state = state.copyWith(
      canCoverNetworkFee: hasEnoughForFee,
    );
  }

  void setCoinsAmount(String amount) {
    if (state.assetData case final CoinAssetData coin) {
      final parsedAmount = double.tryParse(amount) ?? 0.0;
      state = state.copyWith(
        assetData: coin.copyWith(
          amount: parsedAmount,
          priceUSD: parsedAmount * (coin.selectedOption?.coin.priceUSD ?? 0),
        ),
      );
    }
  }

  void setReceiverAddress(String address) {
    state = state.copyWith(receiverAddress: address);
  }

  void selectNetworkFeeOption(NetworkFeeOption selectedOption) {
    state = state.copyWith(
      selectedNetworkFeeOption: selectedOption,
    );
    _checkIfUserCanCoverFee();
  }
}
