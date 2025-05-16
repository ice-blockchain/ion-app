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
        CredentialRequestData instance) =>
    <String, dynamic>{
      if (instance.challengeIdentifier case final value?)
        'challengeIdentifier': value,
      if (instance.credentialName case final value?) 'credentialName': value,
      if (instance.encryptedPrivateKey case final value?)
        'encryptedPrivateKey': value,
      'credentialKind': _$CredentialKindEnumMap[instance.credentialKind]!,
      'credentialInfo': instance.credentialInfo.toJson(),
    };

const _$CredentialKindEnumMap = {
  CredentialKind.Fido2: 'Fido2',
  CredentialKind.Key: 'Key',
  CredentialKind.PasswordProtectedKey: 'PasswordProtectedKey',
  CredentialKind.RecoveryKey: 'RecoveryKey',
};
