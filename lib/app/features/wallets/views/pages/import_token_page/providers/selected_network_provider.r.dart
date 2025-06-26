// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_network_provider.r.g.dart';

@riverpod
class SelectedNetwork extends _$SelectedNetwork {
  @override
  NetworkData? build() => null;

  set network(NetworkData network) {
    state = network;
  }
}
