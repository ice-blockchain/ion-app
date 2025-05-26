// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_key_response.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateKeyResponseImpl _$$CreateKeyResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateKeyResponseImpl(
      id: json['id'] as String,
      scheme: json['scheme'] as String,
      curve: json['curve'] as String,
      publicKey: json['publicKey'] as String,
      status: $enumDecode(_$KeyStatusEnumMap, json['status']),
      custodial: json['custodial'] as bool,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );

Map<String, dynamic> _$$CreateKeyResponseImplToJson(
        _$CreateKeyResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheme': instance.scheme,
      'curve': instance.curve,
      'publicKey': instance.publicKey,
      'status': _$KeyStatusEnumMap[instance.status]!,
      'custodial': instance.custodial,
      'dateCreated': instance.dateCreated.toIso8601String(),
    };

const _$KeyStatusEnumMap = {
  KeyStatus.active: 'Active',
  KeyStatus.archived: 'Archived',
};
