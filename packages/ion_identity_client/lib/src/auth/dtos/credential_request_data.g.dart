// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialRequestData _$CredentialRequestDataFromJson(
        Map<String, dynamic> json) =>
    CredentialRequestData(
      challengeIdentifier: json['challengeIdentifier'] as String,
      credentialName: json['credentialName'] as String,
      credentialKind: json['credentialKind'] as String,
      credentialInfo: CredentialInfo.fromJson(
          json['credentialInfo'] as Map<String, dynamic>),
      encryptedPrivateKey: json['encryptedPrivateKey'] as String,
    );

Map<String, dynamic> _$CredentialRequestDataToJson(
        CredentialRequestData instance) =>
    <String, dynamic>{
      'challengeIdentifier': instance.challengeIdentifier,
      'credentialName': instance.credentialName,
      'credentialKind': instance.credentialKind,
      'credentialInfo': instance.credentialInfo,
      'encryptedPrivateKey': instance.encryptedPrivateKey,
    };
