// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_credential_kinds_2.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportedCredentialKinds2 _$SupportedCredentialKinds2FromJson(
        Map<String, dynamic> json) =>
    SupportedCredentialKinds2(
      $enumDecode(_$CredentialKindEnumMap, json['kind']),
      json['factor'] as String,
      json['requiresSecondFactor'] as bool,
    );

Map<String, dynamic> _$SupportedCredentialKinds2ToJson(
        SupportedCredentialKinds2 instance) =>
    <String, dynamic>{
      'kind': _$CredentialKindEnumMap[instance.kind]!,
      'factor': instance.factor,
      'requiresSecondFactor': instance.requiresSecondFactor,
    };

const _$CredentialKindEnumMap = {
  CredentialKind.Fido2: 'Fido2',
  CredentialKind.Key: 'Key',
  CredentialKind.PasswordProtectedKey: 'PasswordProtectedKey',
  CredentialKind.RecoveryKey: 'RecoveryKey',
};
