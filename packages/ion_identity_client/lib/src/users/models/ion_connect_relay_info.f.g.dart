// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ion_connect_relay_info.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IonConnectRelayInfoImpl _$$IonConnectRelayInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$IonConnectRelayInfoImpl(
      url: json['url'] as String,
      type: $enumDecodeNullable(_$IonConnectRelayTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$IonConnectRelayInfoImplToJson(
        _$IonConnectRelayInfoImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': _$IonConnectRelayTypeEnumMap[instance.type],
    };

const _$IonConnectRelayTypeEnumMap = {
  IonConnectRelayType.read: 'read',
  IonConnectRelayType.write: 'write',
};
