// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/networks/services/get_estimate_fees/models/network_fee.f.dart';

part 'estimate_fee.f.freezed.dart';
part 'estimate_fee.f.g.dart';

@freezed
class EstimateFee with _$EstimateFee {
  factory EstimateFee({
    required String network,
    int? estimatedBaseFee,
    String? kind,
    NetworkFee? fast,
    NetworkFee? standard,
    NetworkFee? slow,
  }) = _EstimateFee;

  factory EstimateFee.fromJson(Map<String, dynamic> json) => _$EstimateFeeFromJson(json);
}
