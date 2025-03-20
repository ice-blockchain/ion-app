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
      dateRequested: DateTime.parse(json['dateRequested'] as String),
      txHash: json['txHash'] as String?,
      fee: json['fee'] as String?,
      dateBroadcasted: json['dateBroadcasted'] == null
          ? null
          : DateTime.parse(json['dateBroadcasted'] as String),
      dateConfirmed: json['dateConfirmed'] == null
          ? null
          : DateTime.parse(json['dateConfirmed'] as String),
      reason: json['reason'] as String?,
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
      'dateRequested': instance.dateRequested.toIso8601String(),
      'txHash': instance.txHash,
      'fee': instance.fee,
      'dateBroadcasted': instance.dateBroadcasted?.toIso8601String(),
      'dateConfirmed': instance.dateConfirmed?.toIso8601String(),
      'reason': instance.reason,
    };
