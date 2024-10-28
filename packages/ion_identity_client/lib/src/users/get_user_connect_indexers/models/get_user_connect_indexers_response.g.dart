// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_connect_indexers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserConnectIndexersResponseImpl
    _$$GetUserConnectIndexersResponseImplFromJson(Map<String, dynamic> json) =>
        _$GetUserConnectIndexersResponseImpl(
          ionConnectIndexers: (json['ionConnectIndexers'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$$GetUserConnectIndexersResponseImplToJson(
        _$GetUserConnectIndexersResponseImpl instance) =>
    <String, dynamic>{
      'ionConnectIndexers': instance.ionConnectIndexers,
    };
