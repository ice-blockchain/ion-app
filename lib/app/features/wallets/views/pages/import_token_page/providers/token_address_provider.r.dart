// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_address_provider.r.g.dart';

@riverpod
class TokenAddress extends _$TokenAddress {
  @override
  String? build() {
    return null;
  }

  set address(String address) {
    state = address;
  }
}
