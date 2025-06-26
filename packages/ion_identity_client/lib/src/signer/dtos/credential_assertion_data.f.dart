// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'credential_assertion_data.f.g.dart';

@JsonSerializable()
class CredentialAssertionData {
  const CredentialAssertionData({
    required this.clientData,
    required this.credId,
    required this.signature,
    this.authenticatorData,
    this.userHandle,
  });

  factory CredentialAssertionData.fromJson(Map<String, dynamic> json) =>
      _$CredentialAssertionDataFromJson(json);

  final String clientData;
  final String credId;
  final String signature;

  @JsonKey(includeIfNull: false)
  final String? authenticatorData;

  @JsonKey(includeIfNull: false)
  final String? userHandle;

  Map<String, dynamic> toJson() => _$CredentialAssertionDataToJson(this);

  @override
  String toString() {
    return 'CredentialAssertionData(clientData: $clientData, credId: $credId, signature: $signature, authenticatorData: $authenticatorData, userHandle: $userHandle)';
  }
}
