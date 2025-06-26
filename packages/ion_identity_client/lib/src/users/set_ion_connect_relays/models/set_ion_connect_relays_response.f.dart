// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_ion_connect_relays_response.f.freezed.dart';
part 'set_ion_connect_relays_response.f.g.dart';

@freezed
class SetIONConnectRelaysResponse with _$SetIONConnectRelaysResponse {
  const factory SetIONConnectRelaysResponse({
    required List<String> ionConnectRelays,
  }) = _SetIONConnectRelaysResponse;

  factory SetIONConnectRelaysResponse.fromJson(Map<String, dynamic> json) =>
      _$SetIONConnectRelaysResponseFromJson(json);
}
