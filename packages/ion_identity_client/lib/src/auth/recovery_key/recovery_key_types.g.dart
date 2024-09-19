// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_key_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialInfo _$CredentialInfoFromJson(Map<String, dynamic> json) => CredentialInfo(
      credId: json['credId'] as String,
      clientData: json['clientData'] as String,
      attestationData: json['attestationData'] as String,
    );

Map<String, dynamic> _$CredentialInfoToJson(CredentialInfo instance) => <String, dynamic>{
      'credId': instance.credId,
      'clientData': instance.clientData,
      'attestationData': instance.attestationData,
    };

CredentialRequestData _$CredentialRequestDataFromJson(Map<String, dynamic> json) =>
    CredentialRequestData(
      challengeIdentifier: json['challengeIdentifier'] as String,
      credentialName: json['credentialName'] as String,
      credentialKind: json['credentialKind'] as String,
      credentialInfo: CredentialInfo.fromJson(json['credentialInfo'] as Map<String, dynamic>),
      encryptedPrivateKey: json['encryptedPrivateKey'] as String,
    );

Map<String, dynamic> _$CredentialRequestDataToJson(CredentialRequestData instance) =>
    <String, dynamic>{
      'challengeIdentifier': instance.challengeIdentifier,
      'credentialName': instance.credentialName,
      'credentialKind': instance.credentialKind,
      'credentialInfo': instance.credentialInfo,
      'encryptedPrivateKey': instance.encryptedPrivateKey,
    };

CredentialChallenge _$CredentialChallengeFromJson(Map<String, dynamic> json) => CredentialChallenge(
      challenge: json['challenge'] as String,
      challengeIdentifier: json['challengeIdentifier'] as String,
    );

Map<String, dynamic> _$CredentialChallengeToJson(CredentialChallenge instance) => <String, dynamic>{
      'challenge': instance.challenge,
      'challengeIdentifier': instance.challengeIdentifier,
    };

CredentialResponse _$CredentialResponseFromJson(Map<String, dynamic> json) => CredentialResponse(
      credentialUuid: json['credentialUuid'] as String,
      credentialId: json['credentialId'] as String,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      isActive: json['isActive'] as bool,
      kind: json['kind'] as String,
      name: json['name'] as String,
      origin: json['origin'] as String,
      relyingPartyId: json['relyingPartyId'] as String,
      publicKey: json['publicKey'] as String,
    );

Map<String, dynamic> _$CredentialResponseToJson(CredentialResponse instance) => <String, dynamic>{
      'credentialUuid': instance.credentialUuid,
      'credentialId': instance.credentialId,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'isActive': instance.isActive,
      'kind': instance.kind,
      'name': instance.name,
      'origin': instance.origin,
      'relyingPartyId': instance.relyingPartyId,
      'publicKey': instance.publicKey,
    };
