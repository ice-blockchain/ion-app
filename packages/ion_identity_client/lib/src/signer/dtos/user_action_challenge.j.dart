// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/allow_credentials.j.dart';
import 'package:ion_identity_client/src/signer/dtos/relying_party.j.dart';
import 'package:ion_identity_client/src/signer/dtos/supported_credential_kinds_2.j.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_action_challenge.j.g.dart';

@JsonSerializable()
class UserActionChallenge {
  UserActionChallenge(
    this.attestation,
    this.userVerification,
    this.externalAuthenticationUrl,
    this.challenge,
    this.challengeIdentifier,
    this.rp,
    this.supportedCredentialKinds,
    this.allowCredentials,
  );

  factory UserActionChallenge.fromJson(JsonObject json) {
    return _$UserActionChallengeFromJson(json);
  }

  final String attestation;
  final String userVerification;
  final String externalAuthenticationUrl;
  final String challenge;
  final String challengeIdentifier;
  final RelyingParty rp;
  final List<SupportedCredentialKinds2> supportedCredentialKinds;
  final AllowCredentials allowCredentials;

  JsonObject toJson() => _$UserActionChallengeToJson(this);
}
