// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NativeTransferRequestBodyImpl _$$NativeTransferRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$NativeTransferRequestBodyImpl(
      kind: json['kind'] as String,
      to: json['to'] as String,
      amount: json['amount'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NativeTransferRequestBodyImplToJson(
        _$NativeTransferRequestBodyImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'to': instance.to,
      'amount': instance.amount,
      'runtimeType': instance.$type,
    };

_$Erc721TransferRequestBodyImpl _$$Erc721TransferRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$Erc721TransferRequestBodyImpl(
      kind: json['kind'] as String,
      contract: json['contract'] as String,
      to: json['to'] as String,
      tokenId: json['tokenId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$Erc721TransferRequestBodyImplToJson(
        _$Erc721TransferRequestBodyImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'contract': instance.contract,
      'to': instance.to,
      'tokenId': instance.tokenId,
      'runtimeType': instance.$type,
    };
