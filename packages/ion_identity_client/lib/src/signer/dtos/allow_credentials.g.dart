// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allow_credentials.dart';

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
    );

Map<String, dynamic> _$AllowCredentialsToJson(AllowCredentials instance) =>
    <String, dynamic>{
      'webauthn': instance.webauthn,
      'key': instance.key,
    };
