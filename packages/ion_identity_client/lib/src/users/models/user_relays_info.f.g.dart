// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_relays_info.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRelaysInfoImpl _$$UserRelaysInfoImplFromJson(Map<String, dynamic> json) =>
    _$UserRelaysInfoImpl(
      masterPubKey: json['masterPubKey'] as String,
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>)
          .map((e) => IonConnectRelayInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserRelaysInfoImplToJson(
        _$UserRelaysInfoImpl instance) =>
    <String, dynamic>{
      'masterPubKey': instance.masterPubKey,
      'ionConnectRelays':
          instance.ionConnectRelays.map((e) => e.toJson()).toList(),
    };
