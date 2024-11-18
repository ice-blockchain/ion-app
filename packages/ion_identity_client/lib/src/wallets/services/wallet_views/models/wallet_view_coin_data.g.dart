// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_coin_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewCoinDataImpl _$$WalletViewCoinDataImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletViewCoinDataImpl(
      totalBalance: json['totalBalance'] as Map<String, dynamic>,
      wallets: (json['wallets'] as List<dynamic>)
          .map((e) => WalletViewWallet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WalletViewCoinDataImplToJson(
        _$WalletViewCoinDataImpl instance) =>
    <String, dynamic>{
      'totalBalance': instance.totalBalance,
      'wallets': instance.wallets.map((e) => e.toJson()).toList(),
    };
