// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ion_connect_indexers_response.freezed.dart';
part 'ion_connect_indexers_response.g.dart';

@freezed
class IonConnectIndexersResponse with _$IonConnectIndexersResponse {
  const factory IonConnectIndexersResponse({
    required List<String> ionConnectIndexers,
  }) = _IonConnectIndexersResponse;

  factory IonConnectIndexersResponse.fromJson(Map<String, dynamic> json) =>
      _$IonConnectIndexersResponseFromJson(json);
}
