// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_response.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeyResponseImpl _$$KeyResponseImplFromJson(Map<String, dynamic> json) =>
    _$KeyResponseImpl(
      id: json['id'] as String,
      scheme: json['scheme'] as String,
      curve: json['curve'] as String,
      publicKey: json['publicKey'] as String,
      name: json['name'] as String?,
      status: $enumDecode(_$KeyStatusEnumMap, json['status']),
      custodial: json['custodial'] as bool,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );

Map<String, dynamic> _$$KeyResponseImplToJson(_$KeyResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheme': instance.scheme,
      'curve': instance.curve,
      'publicKey': instance.publicKey,
      'name': instance.name,
      'status': _$KeyStatusEnumMap[instance.status]!,
      'custodial': instance.custodial,
      'dateCreated': instance.dateCreated.toIso8601String(),
    };

const _$KeyStatusEnumMap = {
  KeyStatus.active: 'Active',
  KeyStatus.archived: 'Archived',
};
