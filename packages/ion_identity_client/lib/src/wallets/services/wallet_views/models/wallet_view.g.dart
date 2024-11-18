// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewImpl _$$WalletViewImplFromJson(Map<String, dynamic> json) =>
    _$WalletViewImpl(
      coins: (json['coins'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, WalletViewCoinData.fromJson(e as Map<String, dynamic>)),
      ),
      createdAt: json['createdAt'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => WalletViewItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      updatedAt: json['updatedAt'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$WalletViewImplToJson(_$WalletViewImpl instance) =>
    <String, dynamic>{
      'coins': instance.coins.map((k, e) => MapEntry(k, e.toJson())),
      'createdAt': instance.createdAt,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
    };
