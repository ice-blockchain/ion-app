// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_history_metadata.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletHistoryMetadataImpl _$$WalletHistoryMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletHistoryMetadataImpl(
      asset: WalletHistoryAssetMetadata.fromJson(
          json['asset'] as Map<String, dynamic>),
      fee: WalletHistoryAssetMetadata.fromJson(
          json['fee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WalletHistoryMetadataImplToJson(
        _$WalletHistoryMetadataImpl instance) =>
    <String, dynamic>{
      'asset': instance.asset.toJson(),
      'fee': instance.fee.toJson(),
    };
