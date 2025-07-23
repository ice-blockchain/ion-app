// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_key_credential_descriptor.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicKeyCredentialDescriptor _$PublicKeyCredentialDescriptorFromJson(
        Map<String, dynamic> json) =>
    PublicKeyCredentialDescriptor(
      json['type'] as String,
      json['id'] as String,
      json['encryptedPrivateKey'] as String?,
    );

Map<String, dynamic> _$PublicKeyCredentialDescriptorToJson(
        PublicKeyCredentialDescriptor instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      if (instance.encryptedPrivateKey case final value?)
        'encryptedPrivateKey': value,
    };
