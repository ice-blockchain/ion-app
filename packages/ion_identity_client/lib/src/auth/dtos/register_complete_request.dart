import 'package:ion_identity_client/src/auth/dtos/signed_challenge.dart';
import 'package:ion_identity_client/src/utils/types.dart';

class RegisterCompleteRequest {
  RegisterCompleteRequest({
    required this.appId,
    required this.signedChallenge,
    required this.temporaryAuthenticationToken,
  });

  factory RegisterCompleteRequest.fromJson(JsonObject json) {
    return RegisterCompleteRequest(
      appId: json['appId'] as String,
      signedChallenge: SignedChallenge.fromJson(json['signedChallenge'] as JsonObject),
      temporaryAuthenticationToken: json['temporaryAuthenticationToken'] as String,
    );
  }

  final String appId;
  final SignedChallenge signedChallenge;
  final String temporaryAuthenticationToken;

  JsonObject toJson() {
    return {
      'appId': appId,
      'signedChallenge': signedChallenge.toJson(),
      'temporaryAuthenticationToken': temporaryAuthenticationToken,
    };
  }
}
