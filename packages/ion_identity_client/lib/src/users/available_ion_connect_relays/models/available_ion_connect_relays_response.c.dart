// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'available_ion_connect_relays_response.c.freezed.dart';
part 'available_ion_connect_relays_response.c.g.dart';

@freezed
class AvailableIONConnectRelaysResponse with _$AvailableIONConnectRelaysResponse {
  const factory AvailableIONConnectRelaysResponse({
    required List<String> ionConnectRelays,
  }) = _AvailableIONConnectRelaysResponse;

  factory AvailableIONConnectRelaysResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableIONConnectRelaysResponseFromJson(json);
}
