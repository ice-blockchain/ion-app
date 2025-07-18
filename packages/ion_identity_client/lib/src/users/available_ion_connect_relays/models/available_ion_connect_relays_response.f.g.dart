// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_ion_connect_relays_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailableIONConnectRelaysResponseImpl
    _$$AvailableIONConnectRelaysResponseImplFromJson(
            Map<String, dynamic> json) =>
        _$AvailableIONConnectRelaysResponseImpl(
          ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>)
              .map((e) =>
                  IonConnectRelayInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$AvailableIONConnectRelaysResponseImplToJson(
        _$AvailableIONConnectRelaysResponseImpl instance) =>
    <String, dynamic>{
      'ionConnectRelays':
          instance.ionConnectRelays.map((e) => e.toJson()).toList(),
    };
