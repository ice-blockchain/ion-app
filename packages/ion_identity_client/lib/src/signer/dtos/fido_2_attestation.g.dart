// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fido_2_attestation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fido2Attestation _$Fido2AttestationFromJson(Map<String, dynamic> json) =>
    Fido2Attestation(
      Fido2AttestationData.fromJson(
          json['credentialInfo'] as Map<String, dynamic>),
      json['credentialKind'] as String,
    );

Map<String, dynamic> _$Fido2AttestationToJson(Fido2Attestation instance) =>
    <String, dynamic>{
      'credentialInfo': instance.credentialInfo.toJson(),
      'credentialKind': instance.credentialKind,
    };
