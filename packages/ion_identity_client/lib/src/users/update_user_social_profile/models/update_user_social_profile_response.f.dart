// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_social_profile_response.f.freezed.dart';
part 'update_user_social_profile_response.f.g.dart';

@freezed
class UpdateUserSocialProfileResponse with _$UpdateUserSocialProfileResponse {
  const factory UpdateUserSocialProfileResponse({
    required String username,
    required String? displayName,
    required String? referral,
    required List<Map<String, dynamic>>? usernameProof,
  }) = _UpdateUserSocialProfileResponse;

  factory UpdateUserSocialProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserSocialProfileResponseFromJson(json);
}
