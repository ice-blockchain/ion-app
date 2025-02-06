import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/duration_converter.dart';
import 'package:ion_identity_client/src/core/network/number_to_string_converter.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

part 'gas_fee.c.g.dart';

part 'gas_fee.c.freezed.dart';

@freezed
class GasFee with _$GasFee {
  const factory GasFee({
    @NumberToStringConverter() required String maxFeePerGas,
    @NumberToStringConverter() required String maxPriorityFeePerGas,
    @DurationConverter() Duration? waitTime,
  }) = _GasFee;

  factory GasFee.fromJson(JsonObject map) => _$GasFeeFromJson(map);
}
