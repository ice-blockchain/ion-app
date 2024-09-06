// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_init_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginInitRequest _$LoginInitRequestFromJson(Map<String, dynamic> json) =>
    LoginInitRequest(
      username: json['username'] as String,
      orgId: json['orgId'] as String,
    );

Map<String, dynamic> _$LoginInitRequestToJson(LoginInitRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'orgId': instance.orgId,
    };
