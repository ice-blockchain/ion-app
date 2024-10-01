// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_action_signing_init_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActionSigningInitRequest _$UserActionSigningInitRequestFromJson(
        Map<String, dynamic> json) =>
    UserActionSigningInitRequest(
      userActionPayload: json['userActionPayload'] as String,
      userActionHttpMethod: json['userActionHttpMethod'] as String,
      userActionHttpPath: json['userActionHttpPath'] as String,
    );

Map<String, dynamic> _$UserActionSigningInitRequestToJson(
        UserActionSigningInitRequest instance) =>
    <String, dynamic>{
      'userActionPayload': instance.userActionPayload,
      'userActionHttpMethod': instance.userActionHttpMethod,
      'userActionHttpPath': instance.userActionHttpPath,
    };
