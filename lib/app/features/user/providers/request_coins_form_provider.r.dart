// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/user/model/request_coins_form_data.f.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.r.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/views/utils/amount_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_coins_form_provider.r.g.dart';

@Riverpod(keepAlive: true)
class RequestCoinsFormController extends _$RequestCoinsFormController {
  @override
  RequestCoinsFormData build() {
    return const RequestCoinsFormData();
  }

  void setCoin(CoinsGroup coin) {
    state = state.copyWith(
      assetData: CoinAssetToSendData(coinsGroup: coin),
      toWallet: null,
    );
  }

  void setContact(String? pubkey, {bool isContactPreselected = false}) {
    state = state.copyWith(contactPubkey: pubkey);
  }

  Future<void> setNetwork(NetworkData network) async {
    final wallets = await ref.read(walletsNotifierProvider.future);
    final wallet = wallets.firstWhereOrNull(
      (wallet) => wallet.network == network.id,
    );

    // Reset current information about network
    state = state.copyWith(
      network: network,
      toWallet: wallet,
    );

    if (state.assetData case final CoinAssetToSendData coin) {
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
    }
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
}
