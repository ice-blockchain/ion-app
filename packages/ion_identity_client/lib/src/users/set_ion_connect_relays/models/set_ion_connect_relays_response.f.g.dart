// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_ion_connect_relays_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetIONConnectRelaysResponseImpl _$$SetIONConnectRelaysResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SetIONConnectRelaysResponseImpl(
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SetIONConnectRelaysResponseImplToJson(
        _$SetIONConnectRelaysResponseImpl instance) =>
    <String, dynamic>{
      'ionConnectRelays': instance.ionConnectRelays,
    };
