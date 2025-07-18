// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/users/models/ion_connect_relay_info.f.dart';

part 'available_ion_connect_relays_response.f.freezed.dart';
part 'available_ion_connect_relays_response.f.g.dart';

@freezed
class AvailableIONConnectRelaysResponse with _$AvailableIONConnectRelaysResponse {
  const factory AvailableIONConnectRelaysResponse({
    required List<IonConnectRelayInfo> ionConnectRelays,
  }) = _AvailableIONConnectRelaysResponse;

  factory AvailableIONConnectRelaysResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableIONConnectRelaysResponseFromJson(json);
}
