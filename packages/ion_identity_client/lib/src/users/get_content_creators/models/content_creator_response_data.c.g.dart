// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_creator_response_data.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentCreatorResponseDataImpl _$$ContentCreatorResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentCreatorResponseDataImpl(
      masterPubKey: json['masterPubKey'] as String,
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ContentCreatorResponseDataImplToJson(
        _$ContentCreatorResponseDataImpl instance) =>
    <String, dynamic>{
      'masterPubKey': instance.masterPubKey,
      'ionConnectRelays': instance.ionConnectRelays,
    };
