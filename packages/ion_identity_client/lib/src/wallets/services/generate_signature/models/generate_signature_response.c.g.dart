// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_signature_response.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GenerateSignatureResponseImpl _$$GenerateSignatureResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GenerateSignatureResponseImpl(
      id: json['id'] as String,
      keyId: json['keyId'] as String,
      requester: Requester.fromJson(json['requester'] as Map<String, dynamic>),
      requestBody: json['requestBody'] as Map<String, dynamic>,
      status: json['status'] as String,
      signature: json['signature'] as Map<String, dynamic>,
      dateRequested: DateTime.parse(json['dateRequested'] as String),
      dateSigned: DateTime.parse(json['dateSigned'] as String),
    );

Map<String, dynamic> _$$GenerateSignatureResponseImplToJson(
        _$GenerateSignatureResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyId': instance.keyId,
      'requester': instance.requester.toJson(),
      'requestBody': instance.requestBody,
      'status': instance.status,
      'signature': instance.signature,
      'dateRequested': instance.dateRequested.toIso8601String(),
      'dateSigned': instance.dateSigned.toIso8601String(),
    };
