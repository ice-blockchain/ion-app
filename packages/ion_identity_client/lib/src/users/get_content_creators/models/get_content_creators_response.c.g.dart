// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_content_creators_response.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetContentCreatorsResponseImpl _$$GetContentCreatorsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetContentCreatorsResponseImpl(
      (json['creators'] as List<dynamic>)
          .map((e) =>
              ContentCreatorResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetContentCreatorsResponseImplToJson(
        _$GetContentCreatorsResponseImpl instance) =>
    <String, dynamic>{
      'creators': instance.creators.map((e) => e.toJson()).toList(),
    };
