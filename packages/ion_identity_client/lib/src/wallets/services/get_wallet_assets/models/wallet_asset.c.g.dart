// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_asset.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletAssetImpl _$$WalletAssetImplFromJson(Map<String, dynamic> json) =>
    _$WalletAssetImpl(
      name: json['name'] as String?,
      contract: json['contract'] as String?,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      balance: json['balance'] as String,
      verified: json['verified'] as bool?,
    );

Map<String, dynamic> _$$WalletAssetImplToJson(_$WalletAssetImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contract': instance.contract,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'balance': instance.balance,
      'verified': instance.verified,
    };
