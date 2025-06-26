// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_credentials.j.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryCredentials _$RecoveryCredentialsFromJson(Map<String, dynamic> json) =>
    RecoveryCredentials(
      identityKeyName: json['identityKeyName'] as String,
      recoveryKeyId: json['recoveryKeyId'] as String,
      recoveryCode: json['recoveryCode'] as String,
    );

Map<String, dynamic> _$RecoveryCredentialsToJson(
        RecoveryCredentials instance) =>
    <String, dynamic>{
      'identityKeyName': instance.identityKeyName,
      'recoveryKeyId': instance.recoveryKeyId,
      'recoveryCode': instance.recoveryCode,
    };
