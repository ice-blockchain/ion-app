// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_assets_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletAssetsDtoImpl _$$WalletAssetsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletAssetsDtoImpl(
      walletId: json['walletId'] as String,
      network: json['network'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => WalletAssetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WalletAssetsDtoImplToJson(
        _$WalletAssetsDtoImpl instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'network': instance.network,
      'assets': instance.assets.map((e) => e.toJson()).toList(),
    };
