// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_info.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialInfo _$CredentialInfoFromJson(Map<String, dynamic> json) =>
    CredentialInfo(
      credId: json['credId'] as String,
      clientData: json['clientData'] as String,
      attestationData: json['attestationData'] as String,
    );

Map<String, dynamic> _$CredentialInfoToJson(CredentialInfo instance) =>
    <String, dynamic>{
      'credId': instance.credId,
      'clientData': instance.clientData,
      'attestationData': instance.attestationData,
    };
