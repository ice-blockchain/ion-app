// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_network_provider.c.g.dart';

@riverpod
class SelectedNetwork extends _$SelectedNetwork {
  @override
  NetworkData? build() => null;

  set network(NetworkData network) {
    state = network;
  }
}
