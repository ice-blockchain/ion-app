// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_content_creators_request.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetContentCreatorsRequestImpl _$$GetContentCreatorsRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GetContentCreatorsRequestImpl(
      excludeMasterPubKeys: (json['excludeMasterPubKeys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$GetContentCreatorsRequestImplToJson(
        _$GetContentCreatorsRequestImpl instance) =>
    <String, dynamic>{
      'excludeMasterPubKeys': instance.excludeMasterPubKeys,
    };
