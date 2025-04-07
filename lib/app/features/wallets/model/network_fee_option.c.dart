// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_fee_type.dart';

part 'network_fee_option.c.freezed.dart';

@freezed
class NetworkFeeOption with _$NetworkFeeOption {
  const factory NetworkFeeOption({
    required double amount,
    required String symbol,
    required double priceUSD,
    required NetworkFeeType? type,
    Duration? arrivalTime,
  }) = _NetworkFeeOption;

  const NetworkFeeOption._();

  String? getDisplayArrivalTime(BuildContext context) {
    if (arrivalTime != null) {
      return '${arrivalTime!.inMinutes} ${context.i18n.wallet_arrival_time_minutes}';
    }

    if (type != null) return type!.getDisplayName(context);

    return null;
  }
}
