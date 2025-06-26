// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'init_twofa_request.f.freezed.dart';
part 'init_twofa_request.f.g.dart';

@freezed
class InitTwoFARequest with _$InitTwoFARequest {
  factory InitTwoFARequest({
    @JsonKey(includeIfNull: false, name: '2FAVerificationCodes')
    Map<String, String>? verificationCodes,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? phoneNumber,
    @JsonKey(includeIfNull: false) String? replace,
  }) = _InitTwoFARequest;

  factory InitTwoFARequest.fromJson(Map<String, dynamic> json) => _$InitTwoFARequestFromJson(json);
}
