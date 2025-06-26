// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_wallet.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewWalletImpl _$$WalletViewWalletImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletViewWalletImpl(
      asset: Map<String, String>.from(json['asset'] as Map),
      network: json['network'] as String,
      walletId: json['walletId'] as String,
    );

Map<String, dynamic> _$$WalletViewWalletImplToJson(
        _$WalletViewWalletImpl instance) =>
    <String, dynamic>{
      'asset': instance.asset,
      'network': instance.network,
      'walletId': instance.walletId,
    };
