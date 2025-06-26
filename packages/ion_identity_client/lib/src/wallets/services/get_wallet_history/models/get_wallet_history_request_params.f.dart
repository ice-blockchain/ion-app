// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_wallet_history_request_params.f.freezed.dart';
part 'get_wallet_history_request_params.f.g.dart';

@freezed
class GetWalletHistoryRequestParams with _$GetWalletHistoryRequestParams {
  const factory GetWalletHistoryRequestParams({
    @JsonKey(includeFromJson: false) int? limit,
    @JsonKey(includeFromJson: false) String? paginationToken,
  }) = _GetWalletHistoryRequestParams;

  factory GetWalletHistoryRequestParams.fromJson(Map<String, dynamic> json) =>
      _$GetWalletHistoryRequestParamsFromJson(json);
}
