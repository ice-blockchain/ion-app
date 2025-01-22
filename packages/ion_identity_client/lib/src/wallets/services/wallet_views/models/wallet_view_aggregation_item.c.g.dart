// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_aggregation_item.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewAggregationItemImpl _$$WalletViewAggregationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletViewAggregationItemImpl(
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) => WalletViewAggregationWallet.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$WalletViewAggregationItemImplToJson(
        _$WalletViewAggregationItemImpl instance) =>
    <String, dynamic>{
      'wallets': instance.wallets.map((e) => e.toJson()).toList(),
      'totalBalance': instance.totalBalance,
    };
