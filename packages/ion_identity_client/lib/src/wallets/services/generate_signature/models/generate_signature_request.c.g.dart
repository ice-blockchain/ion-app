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
    _$SignatureRequestHashImpl instance) {
  final val = <String, dynamic>{
    'kind': instance.kind,
    'hash': instance.hash,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('externalId', instance.externalId);
  return val;
}

_$SignatureRequestMessageImpl _$$SignatureRequestMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$SignatureRequestMessageImpl(
      kind: json['kind'] as String,
      message: json['message'] as String,
      externalId: json['externalId'] as String?,
    );

Map<String, dynamic> _$$SignatureRequestMessageImplToJson(
    _$SignatureRequestMessageImpl instance) {
  final val = <String, dynamic>{
    'kind': instance.kind,
    'message': instance.message,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('externalId', instance.externalId);
  return val;
}
