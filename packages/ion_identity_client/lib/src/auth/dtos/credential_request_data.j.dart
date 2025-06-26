// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/credential_info.j.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_request_data.j.g.dart';

// ignore: constant_identifier_names
enum CredentialKind { Fido2, Key, PasswordProtectedKey, RecoveryKey }

@JsonSerializable()
class CredentialRequestData {
  const CredentialRequestData({
    required this.credentialKind,
    required this.credentialInfo,
    this.encryptedPrivateKey,
    this.credentialName,
    this.challengeIdentifier,
  });

  factory CredentialRequestData.fromJson(JsonObject json) => _$CredentialRequestDataFromJson(json);

  @JsonKey(includeIfNull: false)
  final String? challengeIdentifier;
  @JsonKey(includeIfNull: false)
  final String? credentialName;
  @JsonKey(includeIfNull: false)
  final String? encryptedPrivateKey;
  final CredentialKind credentialKind;
  final CredentialInfo credentialInfo;

  JsonObject toJson() => _$CredentialRequestDataToJson(this);
}
