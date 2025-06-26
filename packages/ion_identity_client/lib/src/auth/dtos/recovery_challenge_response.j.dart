// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_challenge_response.j.g.dart';

@JsonSerializable()
class RecoveryChallengeResponse {
  const RecoveryChallengeResponse({
    required this.temporaryAuthenticationToken,
    required this.challenge,
    required this.allowedRecoveryCredentials,
  });

  factory RecoveryChallengeResponse.fromJson(JsonObject json) =>
      _$RecoveryChallengeResponseFromJson(json);

  final String temporaryAuthenticationToken;
  final String challenge;
  final List<AllowedRecoveryCredential> allowedRecoveryCredentials;
}

@JsonSerializable()
class AllowedRecoveryCredential {
  const AllowedRecoveryCredential({
    required this.id,
    required this.encryptedRecoveryKey,
  });

  factory AllowedRecoveryCredential.fromJson(JsonObject json) =>
      _$AllowedRecoveryCredentialFromJson(json);

  final String id;
  final String encryptedRecoveryKey;

  JsonObject toJson() => _$AllowedRecoveryCredentialToJson(this);
}
