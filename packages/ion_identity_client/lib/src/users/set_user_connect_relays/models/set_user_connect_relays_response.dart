// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_user_connect_relays_response.freezed.dart';
part 'set_user_connect_relays_response.g.dart';

@freezed
class SetUserConnectRelaysResponse with _$SetUserConnectRelaysResponse {
  const factory SetUserConnectRelaysResponse({
    required List<String> ionConnectRelays,
  }) = _SetUserConnectRelaysResponse;

  factory SetUserConnectRelaysResponse.fromJson(Map<String, dynamic> json) =>
      _$SetUserConnectRelaysResponseFromJson(json);
}
