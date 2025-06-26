// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delegated_login_request.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DelegatedLoginRequestImpl _$$DelegatedLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DelegatedLoginRequestImpl(
      username: json['username'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$DelegatedLoginRequestImplToJson(
        _$DelegatedLoginRequestImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'refreshToken': instance.refreshToken,
    };
