// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewImpl _$$WalletViewImplFromJson(Map<String, dynamic> json) =>
    _$WalletViewImpl(
      name: json['name'] as String,
      coins: (json['coins'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
      aggregation: (json['aggregation'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, WalletViewAggregationItem.fromJson(e as Map<String, dynamic>)),
      ),
      symbolGroups: (json['symbolGroups'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$WalletViewImplToJson(_$WalletViewImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'coins': instance.coins.map((e) => e.toJson()).toList(),
      'aggregation':
          instance.aggregation.map((k, e) => MapEntry(k, e.toJson())),
      'symbolGroups': instance.symbolGroups,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
    };
