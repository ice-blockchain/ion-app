// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/send_asset_form_data.c.dart';
import 'package:ion/app/features/wallets/providers/network_fee_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
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
      assetData: const CryptoAssetData.notInitialized(),
    );
  }

  void setNft(NftData nft) {
    // TODO: Not implemented
    // state = state.copyWith(assetData: CryptoAssetData.nft(nft: nft));
  }

  void setCoin(CoinsGroup coin) {
    state = state.copyWith(
      assetData: CryptoAssetData.coin(coinsGroup: coin),
      senderWallet: null,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );
  }

  void setContact(String? pubkey) => state = state.copyWith(contactPubkey: pubkey);

  Future<void> setNetwork(Network network) async {
    final wallets = await ref.read(walletsNotifierProvider.future);
    final wallet = wallets.firstWhereOrNull(
      (wallet) => wallet.network.toLowerCase() == network.serverName.toLowerCase(),
    );

    // Reset current information about network
    state = state.copyWith(
      network: network,
      senderWallet: wallet,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );

    if (state.assetData case final CoinAssetData coin) {
      var selectedOption = coin.coinsGroup.coins.firstWhereOrNull(
        (e) => e.coin.network == network,
      );

      if (selectedOption == null) {
        final coinData = await (await ref.watch(coinsServiceProvider.future))
            .getCoinsByFilters(
              network: network,
              symbol: coin.coinsGroup.abbreviation,
              symbolGroup: coin.coinsGroup.symbolGroup,
            )
            .then((coins) => coins.firstOrNull);
        if (coinData != null) {
          selectedOption = CoinInWalletData(coin: coinData);
        }
      }

      state = state.copyWith(
        assetData: coin.copyWith(
          selectedOption: selectedOption,
        ),
      );

      final networkFeeInfo = await ref.read(
        networkFeeProvider(
          walletId: state.senderWallet?.id,
          network: state.network,
          assetSymbol: coin.coinsGroup.abbreviation,
        ).future,
      );

      if (networkFeeInfo != null) {
        state = state.copyWith(
          networkFeeOptions: networkFeeInfo.networkFeeOptions,
          selectedNetworkFeeOption: networkFeeInfo.networkFeeOptions.firstOrNull,
          networkNativeToken: networkFeeInfo.networkNativeToken,
          assetData: coin.copyWith(
            associatedAssetWithSelectedOption: networkFeeInfo.sendableAsset,
            selectedOption: selectedOption,
          ),
        );
        _checkIfUserCanCoverFee();
      }
    }
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
