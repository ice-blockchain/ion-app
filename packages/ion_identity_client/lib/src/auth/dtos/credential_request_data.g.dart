// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialRequestData _$CredentialRequestDataFromJson(
        Map<String, dynamic> json) =>
    CredentialRequestData(
      credentialKind: json['credentialKind'] as String,
      credentialInfo: CredentialInfo.fromJson(
          json['credentialInfo'] as Map<String, dynamic>),
      encryptedPrivateKey: json['encryptedPrivateKey'] as String,
      credentialName: json['credentialName'] as String?,
      challengeIdentifier: json['challengeIdentifier'] as String?,
    );

Map<String, dynamic> _$CredentialRequestDataToJson(
    CredentialRequestData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('challengeIdentifier', instance.challengeIdentifier);
  writeNotNull('credentialName', instance.credentialName);
  val['credentialKind'] = instance.credentialKind;
  val['credentialInfo'] = instance.credentialInfo;
  val['encryptedPrivateKey'] = instance.encryptedPrivateKey;
  return val;
}
