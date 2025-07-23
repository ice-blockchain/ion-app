// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transfer_request.f.dart';

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
      'dateRequested': instance.dateRequested.toIso8601String(),
      if (instance.txHash case final value?) 'txHash': value,
      if (instance.fee case final value?) 'fee': value,
      if (instance.dateBroadcasted?.toIso8601String() case final value?)
        'dateBroadcasted': value,
      if (instance.dateConfirmed?.toIso8601String() case final value?)
        'dateConfirmed': value,
      if (instance.reason case final value?) 'reason': value,
      if (instance.metadata case final value?) 'metadata': value,
    };
