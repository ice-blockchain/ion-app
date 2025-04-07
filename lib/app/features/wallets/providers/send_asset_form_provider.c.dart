// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/send_asset_form_data.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/network_fee_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/utils/amount_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_asset_form_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SendAssetFormController extends _$SendAssetFormController {
  @override
  SendAssetFormData build() {
    final walletView = ref.watch(currentWalletViewDataProvider).requireValue;
    return SendAssetFormData(
      wallet: walletView,
      arrivalDateTime: DateTime.now(),
      receiverAddress: '',
      assetData: const CryptoAssetToSendData.notInitialized(),
    );
  }

  void setCoin(CoinsGroup coin) {
    state = state.copyWith(
      assetData: CryptoAssetToSendData.coin(coinsGroup: coin),
      senderWallet: null,
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );
  }

  void setContact(String? pubkey, {bool isContactPreselected = false}) {
    state = state.copyWith(contactPubkey: pubkey, isContactPreselected: isContactPreselected);
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
    final wallets = await ref.read(currentWalletViewCryptoWalletsProvider.future);

    // Reset current information about network
    state = state.copyWith(
      network: network,
      senderWallet: wallets.firstWhereOrNull(
        (wallet) => wallet.network == network.id,
      ),
      networkFeeOptions: [],
      selectedNetworkFeeOption: null,
    );

    unawaited(
      _initReceiverAddressFromContact(),
    );

    if (state.assetData case final CoinAssetToSendData coin) {
      var selectedOption = coin.coinsGroup.coins.firstWhereOrNull(
        (e) => e.coin.network == network,
      );

      // TODO: Do we need if (selectedOption == null) code block below? Looks like it will never work
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

      // We should check the case, when user has several crypto wallets in one network.
      // So, if we initially selected a wallet that doesn't have the same id
      // as the selected coin wallet, we must correct this.
      final isCryptoWalletCorrect =
          selectedOption?.walletId != null && selectedOption?.walletId == state.senderWallet?.id;

      state = state.copyWith(
        assetData: coin.copyWith(
          selectedOption: selectedOption,
        ),
        senderWallet: isCryptoWalletCorrect
            ? state.senderWallet
            : wallets.firstWhereOrNull((w) => w.id == selectedOption!.walletId),
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
    state = state.copyWith(
      canCoverNetworkFee: canUserCoverFee(
        selectedFee: state.selectedNetworkFeeOption,
        networkNativeToken: state.networkNativeToken,
      ),
    );
  }

  void setCoinsAmount(String amount) {
    if (state.assetData case final CoinAssetToSendData coin) {
      final parsedAmount = parseAmount(amount) ?? 0.0;
      state = state.copyWith(
        assetData: coin.copyWith(
          amount: parsedAmount,
          amountUSD: parsedAmount * (coin.selectedOption?.coin.priceUSD ?? 0),
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
