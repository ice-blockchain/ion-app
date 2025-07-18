// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_init_request.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterInitRequestImpl _$$RegisterInitRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterInitRequestImpl(
      email: json['email'] as String,
      earlyAccessEmail: json['earlyAccessEmail'] as String?,
    );

Map<String, dynamic> _$$RegisterInitRequestImplToJson(
        _$RegisterInitRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      if (instance.earlyAccessEmail case final value?)
        'earlyAccessEmail': value,
    };
