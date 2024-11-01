// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDetailsImpl _$$UserDetailsImplFromJson(Map<String, dynamic> json) =>
    _$UserDetailsImpl(
      twoFaOptions: (json['2faOptions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ionConnectIndexerRelays:
          (json['ionConnectIndexerRelays'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      name: json['name'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
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
      '2faOptions': instance.twoFaOptions,
      'ionConnectIndexerRelays': instance.ionConnectIndexerRelays,
      'name': instance.name,
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'ionConnectRelays': instance.ionConnectRelays,
    };
