// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_assertion_data.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialAssertionData _$CredentialAssertionDataFromJson(
        Map<String, dynamic> json) =>
    CredentialAssertionData(
      clientData: json['clientData'] as String,
      credId: json['credId'] as String,
      signature: json['signature'] as String,
      authenticatorData: json['authenticatorData'] as String?,
      userHandle: json['userHandle'] as String?,
    );

Map<String, dynamic> _$CredentialAssertionDataToJson(
        CredentialAssertionData instance) =>
    <String, dynamic>{
      'clientData': instance.clientData,
      'credId': instance.credId,
      'signature': instance.signature,
      if (instance.authenticatorData case final value?)
        'authenticatorData': value,
      if (instance.userHandle case final value?) 'userHandle': value,
    };
