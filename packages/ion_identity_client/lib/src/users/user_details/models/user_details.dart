// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    @JsonKey(name: '2faOptions') required List<String> twoFaOptions,
    required List<String> ionConnectIndexerRelays,
    required String name,
    required String userId,
    required String username,
    List<String>? email,
    List<String>? phoneNumber,
    List<String>? ionConnectRelays,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}
