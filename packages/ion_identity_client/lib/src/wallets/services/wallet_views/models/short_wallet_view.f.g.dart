// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_wallet_view.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShortWalletViewImpl _$$ShortWalletViewImplFromJson(
        Map<String, dynamic> json) =>
    _$ShortWalletViewImpl(
      name: json['name'] as String,
      coins: (json['coins'] as List<dynamic>?)
              ?.map(
                  (e) => WalletViewCoinData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      userId: json['userId'] as String,
      id: json['id'] as String,
      symbolGroups: (json['symbolGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$$ShortWalletViewImplToJson(
        _$ShortWalletViewImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'coins': instance.coins.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'id': instance.id,
      'symbolGroups': instance.symbolGroups,
    };
