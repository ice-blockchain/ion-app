// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    required List<String> ionConnectIndexerRelays,
    required String name,
    required String userId,
    required String username,
    required String masterPubKey,
    @JsonKey(name: '2faOptions') List<String>? twoFaOptions,
    List<String>? email,
    List<String>? phoneNumber,
    List<String>? ionConnectRelays,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}
