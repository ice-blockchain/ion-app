import 'package:ion_identity_client/src/auth/dtos/credential_info.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_request_data.g.dart';

@JsonSerializable()
class CredentialRequestData {
  const CredentialRequestData({
    required this.challengeIdentifier,
    required this.credentialName,
    required this.credentialKind,
    required this.credentialInfo,
    required this.encryptedPrivateKey,
  });

  factory CredentialRequestData.fromJson(JsonObject json) => _$CredentialRequestDataFromJson(json);

  final String challengeIdentifier;
  final String credentialName;
  final String credentialKind;
  final CredentialInfo credentialInfo;
  final String encryptedPrivateKey;

  JsonObject toJson() => _$CredentialRequestDataToJson(this);
}
