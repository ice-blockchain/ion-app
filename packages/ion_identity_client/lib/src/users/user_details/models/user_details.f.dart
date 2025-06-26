// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.f.freezed.dart';
part 'user_details.f.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    required List<String> ionConnectIndexerRelays,
    required String masterPubKey,
    String? name,
    String? userId,
    String? username,
    @JsonKey(name: '2faOptions') List<String>? twoFaOptions,
    List<String>? email,
    List<String>? phoneNumber,
    List<String>? ionConnectRelays,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}
