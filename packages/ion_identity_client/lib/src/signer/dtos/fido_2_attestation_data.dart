import 'package:ion_identity_client/src/utils/types.dart';

class Fido2AttestationData {
  Fido2AttestationData(
    this.attestationData,
    this.clientData,
    this.credId,
  );

  factory Fido2AttestationData.fromJson(JsonObject json) {
    return Fido2AttestationData(
      json['attestationData'] as String,
      json['clientData'] as String,
      json['credId'] as String,
    );
  }

  final String attestationData;
  final String clientData;
  final String credId;

  JsonObject toJson() => {
        'attestationData': attestationData,
        'clientData': clientData,
        'credId': credId,
      };

  @override
  String toString() =>
      'Fido2AttestationData(attestationData: $attestationData, clientData: $clientData, credId: $credId)';
}
