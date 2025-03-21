// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
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
      arrivalDateTime: DateTime.now(),
      receiverAddress: '',
      assetData: const CryptoAssetData.notInitialized(),
    );
  }

  void setCoin(CoinsGroup coin) {
    state = state.copyWith(
      assetData: CryptoAssetData.coin(coinsGroup: coin),
      senderWallet: null,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );
  }

  void setNft(NftData nft) {
    state = state.copyWith(
      assetData: CryptoAssetData.nft(nft: nft),
      senderWallet: null,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );
  }

  void setContact(String? pubkey) {
    state = state.copyWith(contactPubkey: pubkey);
    _initReceiverAddressFromContact();
  }

  Future<void> _initReceiverAddressFromContact() async {
    final network = state.network;
    final pubkey = state.contactPubkey;

    if (pubkey != null && network != null) {
      final contactMetadata = await ref.read(userMetadataProvider(pubkey).future);
      final walletAddress = contactMetadata?.data.wallets?[network.id];

      // Assuming that wallet address shouldn't be null because of the check during selection
      if (walletAddress != null) {
        state = state.copyWith(receiverAddress: walletAddress);
      }
    }
  }

  Future<void> setNetwork(NetworkData network) async {
    final wallets = await ref.read(walletsNotifierProvider.future);
    final wallet = wallets.firstWhereOrNull(
      (wallet) => wallet.network == network.id,
    );

    // Reset current information about network
    state = state.copyWith(
      network: network,
      senderWallet: wallet,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );

    unawaited(
      _initReceiverAddressFromContact(),
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
          network: state.network!,
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
