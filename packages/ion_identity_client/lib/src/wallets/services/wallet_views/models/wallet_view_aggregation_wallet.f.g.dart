// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_aggregation_wallet.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewAggregationWalletImpl _$$WalletViewAggregationWalletImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletViewAggregationWalletImpl(
      asset: WalletAsset.fromJson(json['asset'] as Map<String, dynamic>),
      walletId: json['walletId'] as String,
      network: json['network'] as String,
      coinId: json['coinId'] as String?,
    );

Map<String, dynamic> _$$WalletViewAggregationWalletImplToJson(
        _$WalletViewAggregationWalletImpl instance) =>
    <String, dynamic>{
      'asset': instance.asset.toJson(),
      'walletId': instance.walletId,
      'network': instance.network,
      'coinId': instance.coinId,
    };
