// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_assets.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletAssetsImpl _$$WalletAssetsImplFromJson(Map<String, dynamic> json) =>
    _$WalletAssetsImpl(
      walletId: json['walletId'] as String,
      network: json['network'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => WalletAsset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WalletAssetsImplToJson(_$WalletAssetsImpl instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'network': instance.network,
      'assets': instance.assets.map((e) => e.toJson()).toList(),
    };
