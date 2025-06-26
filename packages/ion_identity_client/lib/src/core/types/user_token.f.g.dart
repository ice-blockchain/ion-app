// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserTokenImpl _$$UserTokenImplFromJson(Map<String, dynamic> json) =>
    _$UserTokenImpl(
      username: json['username'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$UserTokenImplToJson(_$UserTokenImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
