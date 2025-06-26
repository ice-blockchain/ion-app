// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delegated_login_response.f.freezed.dart';
part 'delegated_login_response.f.g.dart';

@freezed
class DelegatedLoginResponse with _$DelegatedLoginResponse {
  const factory DelegatedLoginResponse({
    required String token,
  }) = _DelegatedLoginResponse;

  factory DelegatedLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$DelegatedLoginResponseFromJson(json);
}
