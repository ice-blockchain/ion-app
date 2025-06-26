// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_action_signing_init_request.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserActionSigningInitRequestImpl _$$UserActionSigningInitRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UserActionSigningInitRequestImpl(
      userActionPayload: json['userActionPayload'] as String,
      userActionHttpMethod: json['userActionHttpMethod'] as String,
      userActionHttpPath: json['userActionHttpPath'] as String,
      userActionServerKind: json['userActionServerKind'] as String? ?? 'Api',
    );

Map<String, dynamic> _$$UserActionSigningInitRequestImplToJson(
        _$UserActionSigningInitRequestImpl instance) =>
    <String, dynamic>{
      'userActionPayload': instance.userActionPayload,
      'userActionHttpMethod': instance.userActionHttpMethod,
      'userActionHttpPath': instance.userActionHttpPath,
      'userActionServerKind': instance.userActionServerKind,
    };
