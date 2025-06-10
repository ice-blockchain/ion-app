// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/models/coins_group.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/models/receive_coins_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_coins_form_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ReceiveCoinsFormController extends _$ReceiveCoinsFormController {
  @override
  ReceiveCoinsData build() => const ReceiveCoinsData(
        address: null,
        selectedCoin: null,
        selectedNetwork: null,
      );

  void setCoin(CoinsGroup coin) => state = state.copyWith(
        selectedCoin: coin,
        selectedNetwork: null,
        address: null,
      );

  void setNetwork(NetworkData network) => state = state.copyWith(selectedNetwork: network);

  void setWalletAddress(String address) => state = state.copyWith(address: address);
}
