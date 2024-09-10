import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fido_2_attestation.g.dart';

@JsonSerializable()
class Fido2Attestation {
  Fido2Attestation(
    this.credentialInfo,
    this.credentialKind,
  );

  factory Fido2Attestation.fromJson(JsonObject json) => _$Fido2AttestationFromJson(json);

  final Fido2AttestationData credentialInfo;
  final String credentialKind;

  JsonObject toJson() => _$Fido2AttestationToJson(this);
}
