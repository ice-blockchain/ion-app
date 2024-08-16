import 'package:ion_identity_client/src/signer/dtos/allow_credentials.dart';
import 'package:ion_identity_client/src/signer/dtos/relying_party.dart';
import 'package:ion_identity_client/src/signer/dtos/supported_credential_kinds_2.dart';
import 'package:ion_identity_client/src/utils/types.dart';

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
    return UserActionChallenge(
      json['attestation'] as String,
      json['userVerification'] as String,
      json['externalAuthenticationUrl'] as String,
      json['challenge'] as String,
      json['challengeIdentifier'] as String,
      RelyingParty.fromJson(json['rp'] as JsonObject),
      List<SupportedCredentialKinds2>.from(
        json['supportedCredentialKinds'].map(SupportedCredentialKinds2.fromJson) as List<dynamic>,
      ),
      AllowCredentials.fromJson(json['allowCredentials'] as JsonObject),
    );
  }

  final String attestation;
  final String userVerification;
  final String externalAuthenticationUrl;
  final String challenge;
  final String challengeIdentifier;
  final RelyingParty rp;
  final List<SupportedCredentialKinds2> supportedCredentialKinds;
  final AllowCredentials allowCredentials;

  @override
  String toString() {
    return 'UserActionChallenge(attestation: $attestation, userVerification: $userVerification, externalAuthenticationUrl: $externalAuthenticationUrl, challenge: $challenge, challengeIdentifier: $challengeIdentifier, rp: $rp, supportedCredentialKinds: $supportedCredentialKinds, allowCredentials: $allowCredentials)';
  }
}
