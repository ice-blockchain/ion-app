// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_credential_kinds_2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportedCredentialKinds2 _$SupportedCredentialKinds2FromJson(
        Map<String, dynamic> json) =>
    SupportedCredentialKinds2(
      json['kind'] as String,
      json['factor'] as String,
      json['requiresSecondFactor'] as bool,
    );

Map<String, dynamic> _$SupportedCredentialKinds2ToJson(
        SupportedCredentialKinds2 instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'factor': instance.factor,
      'requiresSecondFactor': instance.requiresSecondFactor,
    };
