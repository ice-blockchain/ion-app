import 'package:ion_identity_client/src/signer/dtos.dart';

class IonAuthDataSource {
  IonAuthDataSource._();

  factory IonAuthDataSource.createDefault() {
    return IonAuthDataSource._();
  }

  Future<UserRegistrationChallenge> registerInit({
    required String appId,
    required String username,
  }) async {
    return UserRegistrationChallenge.fromJson(null);
  }

  Future<RegistrationCompletionResponse> registerComplete({
    required String appId,
    required Fido2Attestation attestation,
    required String temporaryAuthenticationToken,
  }) async {
    return RegistrationCompletionResponse.fromJson('');
  }
}
