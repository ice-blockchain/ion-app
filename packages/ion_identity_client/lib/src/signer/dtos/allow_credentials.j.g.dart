// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allow_credentials.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllowCredentials _$AllowCredentialsFromJson(Map<String, dynamic> json) =>
    AllowCredentials(
      (json['webauthn'] as List<dynamic>)
          .map((e) =>
              PublicKeyCredentialDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['key'] as List<dynamic>)
          .map((e) =>
              PublicKeyCredentialDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['passwordProtectedKey'] as List<dynamic>?)
          ?.map((e) =>
              PublicKeyCredentialDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllowCredentialsToJson(AllowCredentials instance) =>
    <String, dynamic>{
      'webauthn': instance.webauthn.map((e) => e.toJson()).toList(),
      'key': instance.key.map((e) => e.toJson()).toList(),
      'passwordProtectedKey':
          instance.passwordProtectedKey?.map((e) => e.toJson()).toList(),
    };
