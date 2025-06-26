// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_challenge.j.g.dart';

@JsonSerializable()
class CredentialChallenge {
  CredentialChallenge({
    required this.challenge,
    required this.challengeIdentifier,
  });

  factory CredentialChallenge.fromJson(JsonObject json) => _$CredentialChallengeFromJson(json);

  final String challenge;
  final String challengeIdentifier;
}
