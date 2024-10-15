// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pseudo_network_signature_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PseudoNetworkSignatureResponseImpl
    _$$PseudoNetworkSignatureResponseImplFromJson(Map<String, dynamic> json) =>
        _$PseudoNetworkSignatureResponseImpl(
          id: json['id'] as String,
          walletId: json['walletId'] as String,
          network: json['network'] as String,
          requester:
              Requester.fromJson(json['requester'] as Map<String, dynamic>),
          requestBody: json['requestBody'] as Map<String, dynamic>,
          status: json['status'] as String,
          signature: json['signature'] as Map<String, dynamic>,
          dateRequested: DateTime.parse(json['dateRequested'] as String),
          dateSigned: DateTime.parse(json['dateSigned'] as String),
        );

Map<String, dynamic> _$$PseudoNetworkSignatureResponseImplToJson(
        _$PseudoNetworkSignatureResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'walletId': instance.walletId,
      'network': instance.network,
      'requester': instance.requester.toJson(),
      'requestBody': instance.requestBody,
      'status': instance.status,
      'signature': instance.signature,
      'dateRequested': instance.dateRequested.toIso8601String(),
      'dateSigned': instance.dateSigned.toIso8601String(),
    };
