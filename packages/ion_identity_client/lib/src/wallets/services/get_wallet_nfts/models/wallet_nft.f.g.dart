// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_nft.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletNftImpl _$$WalletNftImplFromJson(Map<String, dynamic> json) =>
    _$WalletNftImpl(
      kind: json['kind'] as String,
      contract: json['contract'] as String,
      symbol: json['symbol'] as String,
      tokenId: json['tokenId'] as String,
      tokenUri: json['tokenUri'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      network: json['network'] as String,
      collectionImageUri: json['collectionImageUri'] as String,
      walletId: json['walletId'] as String?,
    );

Map<String, dynamic> _$$WalletNftImplToJson(_$WalletNftImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'contract': instance.contract,
      'symbol': instance.symbol,
      'tokenId': instance.tokenId,
      'tokenUri': instance.tokenUri,
      'description': instance.description,
      'name': instance.name,
      'network': instance.network,
      'collectionImageUri': instance.collectionImageUri,
      if (instance.walletId case final value?) 'walletId': value,
    };
