// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_network_provider.c.g.dart';

@riverpod
class SelectedNetwork extends _$SelectedNetwork {
  @override
  Network? build() => null;

  set network(Network network) {
    state = network;
  }
}
