// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    @JsonKey(name: '2faOptions') required List<String> twoFaOptions,
    required String credentialUuid,
    required List<String> ionConnectIndexerRelays,
    required bool isActive,
    required bool isRegistered,
    required bool isServiceAccount,
    required String kind,
    required String name,
    required String orgId,
    required List<String> permissions,
    required String userId,
    required String username,
    List<String>? email,
    List<String>? ionConnectRelays,
    List<String>? phoneNumber,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}
