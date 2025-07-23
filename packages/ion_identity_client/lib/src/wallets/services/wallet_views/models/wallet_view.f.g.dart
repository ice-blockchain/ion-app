// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewImpl _$$WalletViewImplFromJson(Map<String, dynamic> json) =>
    _$WalletViewImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      coins: const CoinInWalletListConverter().fromJson(json['coins'] as List),
      aggregation: (json['aggregation'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k,
                WalletViewAggregationItem.fromJson(e as Map<String, dynamic>)),
          ) ??
          {},
      symbolGroups: (json['symbolGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String,
      nfts: (json['nfts'] as List<dynamic>?)
          ?.map((e) => WalletNft.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WalletViewImplToJson(_$WalletViewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coins': const CoinInWalletListConverter().toJson(instance.coins),
      'aggregation':
          instance.aggregation.map((k, e) => MapEntry(k, e.toJson())),
      'symbolGroups': instance.symbolGroups,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
      if (instance.nfts?.map((e) => e.toJson()).toList() case final value?)
        'nfts': value,
    };
