// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_data.freezed.dart';

@Freezed(copyWith: true)
class WalletData with _$WalletData {
  const factory WalletData({
    required String id,
    required String name,
    required String icon,
    required double balance,
  }) = _WalletData;
}
