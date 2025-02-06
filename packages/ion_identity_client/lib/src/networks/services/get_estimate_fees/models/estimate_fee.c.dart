import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/networks/services/get_estimate_fees/models/gas_fee.c.dart';

part 'estimate_fee.c.g.dart';
part 'estimate_fee.c.freezed.dart';

@freezed
class EstimateFee with _$EstimateFee {
  factory EstimateFee({
    required String network,
    required int? estimatedBaseFee,
    required String? kind,
    required GasFee? fast,
    required GasFee? standard,
    required GasFee? slow,
  }) = _EstimateFee;

  factory EstimateFee.fromJson(Map<String, dynamic> json) => _$EstimateFeeFromJson(json);
}
