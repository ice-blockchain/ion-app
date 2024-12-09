// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_ion_connect_relays_request.c.freezed.dart';
part 'set_ion_connect_relays_request.c.g.dart';

@freezed
class SetIONConnectRelaysRequest with _$SetIONConnectRelaysRequest {
  const factory SetIONConnectRelaysRequest({
    required List<String> followeeList,
  }) = _SetIONConnectRelaysRequest;

  factory SetIONConnectRelaysRequest.fromJson(Map<String, dynamic> json) =>
      _$SetIONConnectRelaysRequestFromJson(json);
}
