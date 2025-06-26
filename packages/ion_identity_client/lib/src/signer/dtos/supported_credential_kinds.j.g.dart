// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_credential_kinds.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportedCredentialKinds _$SupportedCredentialKindsFromJson(
        Map<String, dynamic> json) =>
    SupportedCredentialKinds(
      (json['firstFactor'] as List<dynamic>).map((e) => e as String).toList(),
      (json['secondFactor'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SupportedCredentialKindsToJson(
        SupportedCredentialKinds instance) =>
    <String, dynamic>{
      'firstFactor': instance.firstFactor,
      'secondFactor': instance.secondFactor,
    };
