// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_history_asset_metadata.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletHistoryAssetMetadataImpl _$$WalletHistoryAssetMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletHistoryAssetMetadataImpl(
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num?)?.toInt(),
      verified: json['verified'] as bool?,
    );

Map<String, dynamic> _$$WalletHistoryAssetMetadataImplToJson(
        _$WalletHistoryAssetMetadataImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'verified': instance.verified,
    };
