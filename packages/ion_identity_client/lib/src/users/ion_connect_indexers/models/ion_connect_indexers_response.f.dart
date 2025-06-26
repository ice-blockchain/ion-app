// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ion_connect_indexers_response.f.freezed.dart';
part 'ion_connect_indexers_response.f.g.dart';

@freezed
class IONConnectIndexersResponse with _$IONConnectIndexersResponse {
  const factory IONConnectIndexersResponse({
    required List<String> ionConnectIndexers,
  }) = _IONConnectIndexersResponse;

  factory IONConnectIndexersResponse.fromJson(Map<String, dynamic> json) =>
      _$IONConnectIndexersResponseFromJson(json);
}
