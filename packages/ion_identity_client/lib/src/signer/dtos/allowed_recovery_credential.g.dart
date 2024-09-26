// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allowed_recovery_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllowedRecoveryCredential _$AllowedRecoveryCredentialFromJson(
        Map<String, dynamic> json) =>
    AllowedRecoveryCredential(
      json['id'] as String,
      json['encryptedRecoveryKey'] as String,
    );

Map<String, dynamic> _$AllowedRecoveryCredentialToJson(
        AllowedRecoveryCredential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'encryptedRecoveryKey': instance.encryptedRecoveryKey,
    };
