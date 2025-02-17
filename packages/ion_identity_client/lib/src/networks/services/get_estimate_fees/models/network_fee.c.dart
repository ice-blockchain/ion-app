import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/duration_converter.dart';
import 'package:ion_identity_client/src/core/network/number_to_string_converter.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

part 'network_fee.c.g.dart';

part 'network_fee.c.freezed.dart';

@freezed
class NetworkFee with _$NetworkFee {
  const factory NetworkFee({
    @NumberToStringConverter() required String maxFeePerGas,
    @NumberToStringConverter() required String maxPriorityFeePerGas,
    @DurationConverter() Duration? waitTime,
  }) = _NetworkFee;

  factory NetworkFee.fromJson(JsonObject map) => _$NetworkFeeFromJson(map);
}
