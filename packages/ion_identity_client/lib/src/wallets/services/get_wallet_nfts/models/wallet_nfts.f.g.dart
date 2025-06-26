// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_nfts.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletNftsImpl _$$WalletNftsImplFromJson(Map<String, dynamic> json) =>
    _$WalletNftsImpl(
      walletId: json['walletId'] as String,
      network: json['network'] as String,
      nfts: (json['nfts'] as List<dynamic>)
          .map((e) => WalletNft.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WalletNftsImplToJson(_$WalletNftsImpl instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'network': instance.network,
      'nfts': instance.nfts.map((e) => e.toJson()).toList(),
    };
