// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_request_data.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialRequestData _$CredentialRequestDataFromJson(
        Map<String, dynamic> json) =>
    CredentialRequestData(
      credentialKind:
          $enumDecode(_$CredentialKindEnumMap, json['credentialKind']),
      credentialInfo: CredentialInfo.fromJson(
          json['credentialInfo'] as Map<String, dynamic>),
      encryptedPrivateKey: json['encryptedPrivateKey'] as String?,
      credentialName: json['credentialName'] as String?,
      challengeIdentifier: json['challengeIdentifier'] as String?,
    );

Map<String, dynamic> _$CredentialRequestDataToJson(
    CredentialRequestData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('challengeIdentifier', instance.challengeIdentifier);
  writeNotNull('credentialName', instance.credentialName);
  writeNotNull('encryptedPrivateKey', instance.encryptedPrivateKey);
  val['credentialKind'] = _$CredentialKindEnumMap[instance.credentialKind]!;
  val['credentialInfo'] = instance.credentialInfo.toJson();
  return val;
}

const _$CredentialKindEnumMap = {
  CredentialKind.Fido2: 'Fido2',
  CredentialKind.Key: 'Key',
  CredentialKind.PasswordProtectedKey: 'PasswordProtectedKey',
  CredentialKind.RecoveryKey: 'RecoveryKey',
};
