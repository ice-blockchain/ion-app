// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ion_connect_relay.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IonConnectRelayImpl _$$IonConnectRelayImplFromJson(
        Map<String, dynamic> json) =>
    _$IonConnectRelayImpl(
      url: json['url'] as String,
      type: $enumDecodeNullable(_$IonConnectRelayTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$IonConnectRelayImplToJson(
        _$IonConnectRelayImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': _$IonConnectRelayTypeEnumMap[instance.type],
    };

const _$IonConnectRelayTypeEnumMap = {
  IonConnectRelayType.read: 'read',
  IonConnectRelayType.write: 'write',
};
