// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requester.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequesterImpl _$$RequesterImplFromJson(Map<String, dynamic> json) =>
    _$RequesterImpl(
      userId: json['userId'] as String,
      tokenId: json['tokenId'] as String?,
      appId: json['appId'] as String?,
    );

Map<String, dynamic> _$$RequesterImplToJson(_$RequesterImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      if (instance.tokenId case final value?) 'tokenId': value,
      if (instance.appId case final value?) 'appId': value,
    };
