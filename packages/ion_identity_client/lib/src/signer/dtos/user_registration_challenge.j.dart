// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/recovery_challenge_response.j.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/authenticator_selection_criteria.j.dart';
import 'package:ion_identity_client/src/signer/dtos/public_key_credential_descriptor.j.dart';
import 'package:ion_identity_client/src/signer/dtos/public_key_credential_parameters.j.dart';
import 'package:ion_identity_client/src/signer/dtos/relying_party.j.dart';
import 'package:ion_identity_client/src/signer/dtos/supported_credential_kinds.j.dart';
import 'package:ion_identity_client/src/signer/dtos/user_information.j.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_registration_challenge.j.g.dart';

@JsonSerializable()
class UserRegistrationChallenge {
  const UserRegistrationChallenge(
    this.temporaryAuthenticationToken,
    this.rp,
    this.user,
    this.supportedCredentialKinds,
    this.otpUrl,
    this.challenge,
    this.authenticatorSelection,
    this.attestation,
    this.pubKeyCredParams,
    this.excludeCredentials,
    this.allowedRecoveryCredentials,
  );

  factory UserRegistrationChallenge.fromJson(JsonObject json) =>
      _$UserRegistrationChallengeFromJson(json);

  final String? temporaryAuthenticationToken;
  final RelyingParty rp;
  final UserInformation user;
  final SupportedCredentialKinds? supportedCredentialKinds;
  final String? otpUrl;
  final String challenge;
  final AuthenticatorSelectionCriteria? authenticatorSelection;
  final String attestation;
  final List<PublicKeyCredentialParameters> pubKeyCredParams;
  final List<PublicKeyCredentialDescriptor> excludeCredentials;
  final List<AllowedRecoveryCredential>? allowedRecoveryCredentials;

  JsonObject toJson() => _$UserRegistrationChallengeToJson(this);

  @override
  String toString() {
    return 'UserRegistrationChallenge(temporaryAuthenticationToken: $temporaryAuthenticationToken, rp: $rp, user: $user, supportedCredentialKinds: $supportedCredentialKinds, otpUrl: $otpUrl, challenge: $challenge, authenticatorSelection: $authenticatorSelection, attestation: $attestation, pubKeyCredParams: $pubKeyCredParams, excludeCredentials: $excludeCredentials)';
  }
}
