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
    CredentialAssertionData instance) {
  final val = <String, dynamic>{
    'clientData': instance.clientData,
    'credId': instance.credId,
    'signature': instance.signature,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('authenticatorData', instance.authenticatorData);
  writeNotNull('userHandle', instance.userHandle);
  return val;
}
