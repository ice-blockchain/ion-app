// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthenticationImpl _$$AuthenticationImplFromJson(Map<String, dynamic> json) =>
    _$AuthenticationImpl(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$AuthenticationImplToJson(
        _$AuthenticationImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
