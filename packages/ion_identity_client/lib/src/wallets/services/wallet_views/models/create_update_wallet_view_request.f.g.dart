// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_update_wallet_view_request.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateWalletViewRequestImpl _$$CreateWalletViewRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateWalletViewRequestImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => WalletViewCoinData.fromJson(e as Map<String, dynamic>))
          .toList(),
      symbolGroups: (json['symbolGroups'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$CreateWalletViewRequestImplToJson(
        _$CreateWalletViewRequestImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'symbolGroups': instance.symbolGroups,
      'name': instance.name,
    };
