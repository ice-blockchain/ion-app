// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_key_request.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateKeyRequestImpl _$$CreateKeyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateKeyRequestImpl(
      scheme: json['scheme'] as String,
      curve: json['curve'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$CreateKeyRequestImplToJson(
        _$CreateKeyRequestImpl instance) =>
    <String, dynamic>{
      'scheme': instance.scheme,
      'curve': instance.curve,
      if (instance.name case final value?) 'name': value,
    };
