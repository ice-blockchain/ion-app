import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

class SignedChallenge {
  SignedChallenge({
    required this.firstFactorCredential,
  });

  factory SignedChallenge.fromJson(JsonObject json) {
    return SignedChallenge(
      firstFactorCredential: Fido2Attestation.fromJson(json['firstFactorCredential'] as JsonObject),
    );
  }

  final Fido2Attestation firstFactorCredential;

  JsonObject toJson() {
    return {
      'firstFactorCredential': firstFactorCredential.toJson(),
    };
  }

  @override
  String toString() => 'SignedChallenge(firstFactorCredential: $firstFactorCredential)';
}
