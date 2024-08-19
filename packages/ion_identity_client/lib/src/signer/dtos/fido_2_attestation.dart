import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation_data.dart';

class Fido2Attestation {
  Fido2Attestation(
    this.credentialInfo,
    this.credentialKind,
  );

  factory Fido2Attestation.fromJson(JsonObject json) {
    return Fido2Attestation(
      Fido2AttestationData.fromJson(json['credentialInfo'] as JsonObject),
      json['credentialKind'] as String,
    );
  }

  final Fido2AttestationData credentialInfo;
  final String credentialKind;

  JsonObject toJson() => {
        'credentialInfo': credentialInfo.toJson(),
        'credentialKind': credentialKind,
      };

  @override
  String toString() =>
      'Fido2Attestation(credentialInfo: $credentialInfo, credentialKind: $credentialKind)';
}
