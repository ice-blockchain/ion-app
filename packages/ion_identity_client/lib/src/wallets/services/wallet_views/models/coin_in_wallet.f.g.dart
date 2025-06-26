// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_in_wallet.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoinInWalletImpl _$$CoinInWalletImplFromJson(Map<String, dynamic> json) =>
    _$CoinInWalletImpl(
      coin: Coin.fromJson(json['coin'] as Map<String, dynamic>),
      walletId: json['walletId'] as String?,
    );

Map<String, dynamic> _$$CoinInWalletImplToJson(_$CoinInWalletImpl instance) =>
    <String, dynamic>{
      'coin': instance.coin.toJson(),
      'walletId': instance.walletId,
    };
