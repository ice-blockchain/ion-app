// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fido_2_attestation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fido2AttestationData _$Fido2AttestationDataFromJson(
        Map<String, dynamic> json) =>
    Fido2AttestationData(
      json['attestationData'] as String,
      json['clientData'] as String,
      json['credId'] as String,
    );

Map<String, dynamic> _$Fido2AttestationDataToJson(
        Fido2AttestationData instance) =>
    <String, dynamic>{
      'attestationData': instance.attestationData,
      'clientData': instance.clientData,
      'credId': instance.credId,
    };
