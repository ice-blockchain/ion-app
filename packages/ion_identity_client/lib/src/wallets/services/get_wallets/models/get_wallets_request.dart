// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_wallets_request.freezed.dart';
part 'get_wallets_request.g.dart';

@freezed
class GetWalletsResponse with _$GetWalletsResponse {
  factory GetWalletsResponse({
    required String username,
    @JsonKey(includeFromJson: false) required String? paginationToken,
  }) = _GetWalletsResponse;

  factory GetWalletsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetWalletsResponseFromJson(json);
}
