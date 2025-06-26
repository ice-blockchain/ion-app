// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_response.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialResponse _$CredentialResponseFromJson(Map<String, dynamic> json) =>
    CredentialResponse(
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

Map<String, dynamic> _$CredentialResponseToJson(CredentialResponse instance) =>
    <String, dynamic>{
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
