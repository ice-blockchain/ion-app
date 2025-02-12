// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network_fee_type.dart';

part 'network_fee_option.c.freezed.dart';

@freezed
class NetworkFeeOption with _$NetworkFeeOption {
  const factory NetworkFeeOption({
    required NetworkFeeType type,
    required double amount,
    required double priceUSD,
    required String symbol,
    Duration? arrivalTime,
  }) = _NetworkFeeOption;
}
