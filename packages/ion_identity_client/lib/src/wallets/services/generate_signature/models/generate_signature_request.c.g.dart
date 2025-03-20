// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_signature_request.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignatureRequestHashImpl _$$SignatureRequestHashImplFromJson(
        Map<String, dynamic> json) =>
    _$SignatureRequestHashImpl(
      kind: json['kind'] as String,
      hash: json['hash'] as String,
      externalId: json['externalId'] as String?,
    );

Map<String, dynamic> _$$SignatureRequestHashImplToJson(
        _$SignatureRequestHashImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'hash': instance.hash,
      if (instance.externalId case final value?) 'externalId': value,
    };

_$SignatureRequestMessageImpl _$$SignatureRequestMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$SignatureRequestMessageImpl(
      kind: json['kind'] as String,
      message: json['message'] as String,
      externalId: json['externalId'] as String?,
    );

Map<String, dynamic> _$$SignatureRequestMessageImplToJson(
        _$SignatureRequestMessageImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'message': instance.message,
      if (instance.externalId case final value?) 'externalId': value,
    };
