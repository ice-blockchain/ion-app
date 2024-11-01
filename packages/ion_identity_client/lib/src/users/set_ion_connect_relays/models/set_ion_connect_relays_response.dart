// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_ion_connect_relays_response.freezed.dart';
part 'set_ion_connect_relays_response.g.dart';

@freezed
class SetIonConnectRelaysResponse with _$SetIonConnectRelaysResponse {
  const factory SetIonConnectRelaysResponse({
    required List<String> ionConnectRelays,
  }) = _SetIonConnectRelaysResponse;

  factory SetIonConnectRelaysResponse.fromJson(Map<String, dynamic> json) =>
      _$SetIonConnectRelaysResponseFromJson(json);
}
