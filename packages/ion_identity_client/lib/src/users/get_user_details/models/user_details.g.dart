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
      credentialUuid: json['credentialUuid'] as String,
      ionConnectIndexerRelays:
          (json['ionConnectIndexerRelays'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      isActive: json['isActive'] as bool,
      isRegistered: json['isRegistered'] as bool,
      isServiceAccount: json['isServiceAccount'] as bool,
      kind: json['kind'] as String,
      name: json['name'] as String,
      orgId: json['orgId'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      userId: json['userId'] as String,
      username: json['username'] as String,
      email:
          (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ionConnectRelays: (json['ionConnectRelays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      phoneNumber: (json['phoneNumber'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserDetailsImplToJson(_$UserDetailsImpl instance) =>
    <String, dynamic>{
      '2faOptions': instance.twoFaOptions,
      'credentialUuid': instance.credentialUuid,
      'ionConnectIndexerRelays': instance.ionConnectIndexerRelays,
      'isActive': instance.isActive,
      'isRegistered': instance.isRegistered,
      'isServiceAccount': instance.isServiceAccount,
      'kind': instance.kind,
      'name': instance.name,
      'orgId': instance.orgId,
      'permissions': instance.permissions,
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'ionConnectRelays': instance.ionConnectRelays,
      'phoneNumber': instance.phoneNumber,
    };
