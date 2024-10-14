// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_history_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletHistoryRecordImpl _$$WalletHistoryRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletHistoryRecordImpl(
      walletId: json['walletId'] as String,
      network: json['network'] as String,
      kind: json['kind'] as String,
      direction: json['direction'] as String,
      blockNumber: (json['blockNumber'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      txHash: json['txHash'] as String,
      index: json['index'] as String?,
      contract: json['contract'] as String?,
      from: json['from'] as String,
      to: json['to'] as String,
      value: json['value'] as String,
      fee: json['fee'] as String,
      metadata: WalletHistoryMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WalletHistoryRecordImplToJson(
        _$WalletHistoryRecordImpl instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'network': instance.network,
      'kind': instance.kind,
      'direction': instance.direction,
      'blockNumber': instance.blockNumber,
      'timestamp': instance.timestamp.toIso8601String(),
      'txHash': instance.txHash,
      'index': instance.index,
      'contract': instance.contract,
      'from': instance.from,
      'to': instance.to,
      'value': instance.value,
      'fee': instance.fee,
      'metadata': instance.metadata.toJson(),
    };
