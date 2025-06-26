// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delegated_login_request.f.freezed.dart';
part 'delegated_login_request.f.g.dart';

@freezed
class DelegatedLoginRequest with _$DelegatedLoginRequest {
  const factory DelegatedLoginRequest({
    required String username,
    required String refreshToken,
  }) = _DelegatedLoginRequest;

  factory DelegatedLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$DelegatedLoginRequestFromJson(json);
}
