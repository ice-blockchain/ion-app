// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_connect_indexers_response.freezed.dart';
part 'get_user_connect_indexers_response.g.dart';

@freezed
class GetUserConnectIndexersResponse with _$GetUserConnectIndexersResponse {
  const factory GetUserConnectIndexersResponse({
    required List<String> ionConnectIndexers,
  }) = _GetUserConnectIndexersResponse;

  factory GetUserConnectIndexersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserConnectIndexersResponseFromJson(json);
}
