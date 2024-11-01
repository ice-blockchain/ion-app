// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_ion_connect_relays_request.freezed.dart';
part 'set_ion_connect_relays_request.g.dart';

@freezed
class SetIonConnectRelaysRequest with _$SetIonConnectRelaysRequest {
  const factory SetIonConnectRelaysRequest({
    required List<String> followeeList,
  }) = _SetIonConnectRelaysRequest;

  factory SetIonConnectRelaysRequest.fromJson(Map<String, dynamic> json) =>
      _$SetIonConnectRelaysRequestFromJson(json);
}
