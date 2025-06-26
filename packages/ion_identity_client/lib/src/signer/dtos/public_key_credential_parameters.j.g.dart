// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_key_credential_parameters.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicKeyCredentialParameters _$PublicKeyCredentialParametersFromJson(
        Map<String, dynamic> json) =>
    PublicKeyCredentialParameters(
      json['type'] as String,
      (json['alg'] as num).toInt(),
    );

Map<String, dynamic> _$PublicKeyCredentialParametersToJson(
        PublicKeyCredentialParameters instance) =>
    <String, dynamic>{
      'type': instance.type,
      'alg': instance.alg,
    };
