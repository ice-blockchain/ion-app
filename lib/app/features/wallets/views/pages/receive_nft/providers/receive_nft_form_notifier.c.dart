// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/receive_nft_form.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_nft_form_notifier.c.g.dart';

@Riverpod(keepAlive: true)
class ReceiveNftFormNotifier extends _$ReceiveNftFormNotifier {
  @override
  ReceiveNftForm build() => const ReceiveNftForm(address: null, selectedNetwork: null);

  void setNetwork(NetworkData network) => state = state.copyWith(selectedNetwork: network);

  void setWalletAddress(String address) => state = state.copyWith(address: address);
}
