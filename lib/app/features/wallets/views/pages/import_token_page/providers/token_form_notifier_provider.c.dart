// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/model/token_form.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_form_notifier_provider.c.g.dart';

@riverpod
class TokenFormNotifier extends _$TokenFormNotifier {
  @override
  TokenForm build() => const TokenForm();

  set address(String address) {
    state = state.copyWith(address: address);
  }

  set network(NetworkData network) {
    state = state.copyWith(network: network);
  }

  set symbol(String symbol) {
    state = state.copyWith(symbol: symbol);
  }

  set decimals(int? decimals) {
    state = state.copyWith(decimals: decimals);
  }
}
