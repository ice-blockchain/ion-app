// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDetailsImpl _$$UserDetailsImplFromJson(Map<String, dynamic> json) =>
    _$UserDetailsImpl(
      ionConnectIndexerRelays:
          (json['ionConnectIndexerRelays'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      name: json['name'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      masterPubKey: json['masterPubKey'] as String,
      twoFaOptions: (json['2faOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      email:
          (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
      phoneNumber: (json['phoneNumber'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserDetailsImplToJson(_$UserDetailsImpl instance) =>
    <String, dynamic>{
      'ionConnectIndexerRelays': instance.ionConnectIndexerRelays,
      'name': instance.name,
      'userId': instance.userId,
      'username': instance.username,
      'masterPubKey': instance.masterPubKey,
      '2faOptions': instance.twoFaOptions,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'ionConnectRelays': instance.ionConnectRelays,
    };
