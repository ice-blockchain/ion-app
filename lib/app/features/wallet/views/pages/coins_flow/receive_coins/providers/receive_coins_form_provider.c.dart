// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/receive_coins_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_coins_form_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ReceiveCoinsFormController extends _$ReceiveCoinsFormController {
  @override
  ReceiveCoinsData build() => const ReceiveCoinsData(
        address: null,
        selectedCoin: null,
        selectedNetwork: NetworkType.eth,
      );

  void setCoin(CoinInWalletData coin) => state = state.copyWith(selectedCoin: coin);

  void setNetwork(NetworkType network) => state = state.copyWith(selectedNetwork: network);
}
