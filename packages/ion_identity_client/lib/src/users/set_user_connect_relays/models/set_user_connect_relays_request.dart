// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_user_connect_relays_request.freezed.dart';
part 'set_user_connect_relays_request.g.dart';

@freezed
class SetUserConnectRelaysRequest with _$SetUserConnectRelaysRequest {
  const factory SetUserConnectRelaysRequest({
    required List<String> followeeList,
  }) = _SetUserConnectRelaysRequest;

  factory SetUserConnectRelaysRequest.fromJson(Map<String, dynamic> json) =>
      _$SetUserConnectRelaysRequestFromJson(json);
}
