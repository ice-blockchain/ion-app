import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fido_2_attestation_data.g.dart';

@JsonSerializable()
class Fido2AttestationData {
  Fido2AttestationData(
    this.attestationData,
    this.clientData,
    this.credId,
  );

  factory Fido2AttestationData.fromJson(JsonObject json) => _$Fido2AttestationDataFromJson(json);

  final String attestationData;
  final String clientData;
  final String credId;

  JsonObject toJson() => _$Fido2AttestationDataToJson(this);
}
