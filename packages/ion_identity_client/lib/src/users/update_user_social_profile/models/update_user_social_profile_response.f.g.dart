// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_social_profile_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserSocialProfileResponseImpl
    _$$UpdateUserSocialProfileResponseImplFromJson(Map<String, dynamic> json) =>
        _$UpdateUserSocialProfileResponseImpl(
          username: json['username'] as String,
          displayName: json['displayName'] as String?,
          referral: json['referral'] as String?,
          usernameProof: (json['usernameProof'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList(),
          referralMasterKey: json['referralMasterKey'] as String?,
        );

Map<String, dynamic> _$$UpdateUserSocialProfileResponseImplToJson(
        _$UpdateUserSocialProfileResponseImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      if (instance.displayName case final value?) 'displayName': value,
      if (instance.referral case final value?) 'referral': value,
      if (instance.usernameProof case final value?) 'usernameProof': value,
      if (instance.referralMasterKey case final value?)
        'referralMasterKey': value,
    };
