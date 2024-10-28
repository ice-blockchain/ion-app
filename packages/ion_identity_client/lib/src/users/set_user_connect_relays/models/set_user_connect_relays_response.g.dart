// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_user_connect_relays_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetUserConnectRelaysResponseImpl _$$SetUserConnectRelaysResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SetUserConnectRelaysResponseImpl(
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SetUserConnectRelaysResponseImplToJson(
        _$SetUserConnectRelaysResponseImpl instance) =>
    <String, dynamic>{
      'ionConnectRelays': instance.ionConnectRelays,
    };
