import 'package:ion_identity_client/src/core/types/types.dart';

class Fido2AssertionData {
  Fido2AssertionData(
    this.clientData,
    this.credId,
    this.signature,
    this.authenticatorData,
    this.userHandle,
  );

  factory Fido2AssertionData.fromJson(JsonObject json) {
    return Fido2AssertionData(
      json['clientData'] as String,
      json['credId'] as String,
      json['signature'] as String,
      json['authenticatorData'] as String,
      json['userHandle'] as String,
    );
  }

  final String clientData;
  final String credId;
  final String signature;
  final String authenticatorData;
  final String? userHandle;

  JsonObject toJson() => {
        'clientData': clientData,
        'credId': credId,
        'signature': signature,
        'authenticatorData': authenticatorData,
        'userHandle': userHandle,
      };

  @override
  String toString() {
    return 'Fido2AssertionData(clientData: $clientData, credId: $credId, signature: $signature, authenticatorData: $authenticatorData, userHandle: $userHandle)';
  }
}
