// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_social_profile_data.c.freezed.dart';
part 'user_social_profile_data.c.g.dart';

@freezed
class UserSocialProfileData with _$UserSocialProfileData {
  @JsonSerializable(includeIfNull: false)
  const factory UserSocialProfileData({
    String? username,
    String? displayName,
    String? referral,
  }) = _UserSocialProfileData;

  factory UserSocialProfileData.fromJson(Map<String, dynamic> json) =>
      _$UserSocialProfileDataFromJson(json);
}
