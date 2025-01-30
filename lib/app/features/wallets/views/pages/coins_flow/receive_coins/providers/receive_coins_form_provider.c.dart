// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/receive_coins_data.c.dart';
import 'package:ion/app/services/wallets/wallets_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
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

  void setCoin(CoinsGroup coin) => state = state.copyWith(selectedCoin: coin);

  void setNetwork(Network network) => state = state.copyWith(selectedNetwork: network);

  void setWalletAddress(String address) => state = state.copyWith(address: address);
}
