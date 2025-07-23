// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_coin_data.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewCoinDataImpl _$$WalletViewCoinDataImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletViewCoinDataImpl(
      coinId: json['coinId'] as String,
      walletId: json['walletId'] as String?,
    );

Map<String, dynamic> _$$WalletViewCoinDataImplToJson(
        _$WalletViewCoinDataImpl instance) =>
    <String, dynamic>{
      'coinId': instance.coinId,
      if (instance.walletId case final value?) 'walletId': value,
    };
