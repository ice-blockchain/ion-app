// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_init_request.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterInitRequest _$RegisterInitRequestFromJson(Map<String, dynamic> json) =>
    RegisterInitRequest(
      email: json['email'] as String,
      earlyAccessEmail: json['earlyAccessEmail'] as String?,
    );

Map<String, dynamic> _$RegisterInitRequestToJson(
        RegisterInitRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'earlyAccessEmail': instance.earlyAccessEmail,
    };
