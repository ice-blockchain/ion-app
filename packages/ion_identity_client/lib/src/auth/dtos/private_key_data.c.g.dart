// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_key_data.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateKeyData _$PrivateKeyDataFromJson(Map<String, dynamic> json) =>
    PrivateKeyData(
      encryptedPrivateKey: json['encryptedPrivateKey'] as String?,
      hexEncodedPrivateKeyBytes: json['hexEncodedPrivateKeyBytes'] as String?,
    );

Map<String, dynamic> _$PrivateKeyDataToJson(PrivateKeyData instance) =>
    <String, dynamic>{
      'encryptedPrivateKey': instance.encryptedPrivateKey,
      'hexEncodedPrivateKeyBytes': instance.hexEncodedPrivateKeyBytes,
    };
