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
      'name': instance.name,
      'userId': instance.userId,
      'username': instance.username,
      '2faOptions': instance.twoFaOptions,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'ionConnectRelays':
          instance.ionConnectRelays?.map((e) => e.toJson()).toList(),
    };
