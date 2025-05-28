// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transfer_request.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletTransferRequestImpl _$$WalletTransferRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletTransferRequestImpl(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      network: json['network'] as String,
      requester: Requester.fromJson(json['requester'] as Map<String, dynamic>),
      requestBody: TransferRequestBody.fromJson(
          json['requestBody'] as Map<String, dynamic>),
      status: json['status'] as String,
      dateRequested: (json['dateRequested'] as num).toInt(),
      txHash: json['txHash'] as String?,
      fee: json['fee'] as String?,
      dateBroadcasted: (json['dateBroadcasted'] as num?)?.toInt(),
      dateConfirmed: (json['dateConfirmed'] as num?)?.toInt(),
      reason: json['reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$WalletTransferRequestImplToJson(
        _$WalletTransferRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'walletId': instance.walletId,
      'network': instance.network,
      'requester': instance.requester.toJson(),
      'requestBody': instance.requestBody.toJson(),
      'status': instance.status,
      'dateRequested': instance.dateRequested,
      'txHash': instance.txHash,
      'fee': instance.fee,
      'dateBroadcasted': instance.dateBroadcasted,
      'dateConfirmed': instance.dateConfirmed,
      'reason': instance.reason,
      'metadata': instance.metadata,
    };
