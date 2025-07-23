// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDetailsImpl _$$UserDetailsImplFromJson(Map<String, dynamic> json) =>
    _$UserDetailsImpl(
      ionConnectIndexerRelays:
          (json['ionConnectIndexerRelays'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      masterPubKey: json['masterPubKey'] as String,
      name: json['name'] as String?,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      twoFaOptions: (json['2faOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      email:
          (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
      phoneNumber: (json['phoneNumber'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>?)
          ?.map((e) => IonConnectRelayInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserDetailsImplToJson(_$UserDetailsImpl instance) =>
    <String, dynamic>{
      'ionConnectIndexerRelays': instance.ionConnectIndexerRelays,
      'masterPubKey': instance.masterPubKey,
      if (instance.name case final value?) 'name': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.username case final value?) 'username': value,
      if (instance.twoFaOptions case final value?) '2faOptions': value,
      if (instance.email case final value?) 'email': value,
      if (instance.phoneNumber case final value?) 'phoneNumber': value,
      if (instance.ionConnectRelays?.map((e) => e.toJson()).toList()
          case final value?)
        'ionConnectRelays': value,
    };
