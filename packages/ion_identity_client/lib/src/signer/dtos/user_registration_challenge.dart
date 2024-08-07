import 'package:ion_identity_client/src/signer/dtos/authenticator_selection_criteria.dart';
import 'package:ion_identity_client/src/signer/dtos/public_key_credential_descriptor.dart';
import 'package:ion_identity_client/src/signer/dtos/public_key_credential_parameters.dart';
import 'package:ion_identity_client/src/signer/dtos/relying_party.dart';
import 'package:ion_identity_client/src/signer/dtos/supported_credential_kinds.dart';
import 'package:ion_identity_client/src/signer/dtos/user_information.dart';
import 'package:ion_identity_client/src/utils/types.dart';

class UserRegistrationChallenge {
  UserRegistrationChallenge(
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
  );

  factory UserRegistrationChallenge.fromJson(JsonObject json) {
    return UserRegistrationChallenge(
      json['temporaryAuthenticationToken'] as String,
      RelyingParty.fromJson(json['rp'] as JsonObject),
      UserInformation.fromJson(json['user']),
      SupportedCredentialKinds.fromJson(json['supportedCredentialKinds'] as JsonObject),
      json['otpUrl'] as String,
      json['challenge'] as String,
      AuthenticatorSelectionCriteria.fromJson(json['authenticatorSelection'] as JsonObject),
      json['attestation'] as String,
      List<PublicKeyCredentialParameters>.from(
        (json['pubKeyCredParams'] as Iterable<dynamic>)
            .map((e) => PublicKeyCredentialParameters.fromJson(e as JsonObject)),
      ),
      List<PublicKeyCredentialDescriptor>.from(
        (json['excludeCredentials'] as Iterable<dynamic>)
            .map((e) => PublicKeyCredentialDescriptor.fromJson(e as JsonObject)),
      ),
    );
  }

  final String temporaryAuthenticationToken;
  final RelyingParty rp;
  final UserInformation user;
  final SupportedCredentialKinds supportedCredentialKinds;
  final String otpUrl;
  final String challenge;
  final AuthenticatorSelectionCriteria authenticatorSelection;
  final String attestation;
  final List<PublicKeyCredentialParameters> pubKeyCredParams;
  final List<PublicKeyCredentialDescriptor> excludeCredentials;
}
