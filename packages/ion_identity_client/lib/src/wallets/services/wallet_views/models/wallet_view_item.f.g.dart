// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_view_item.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletViewItemImpl _$$WalletViewItemImplFromJson(Map<String, dynamic> json) =>
    _$WalletViewItemImpl(
      coinId: json['coinId'] as String,
      walletId: json['walletId'] as String?,
    );

Map<String, dynamic> _$$WalletViewItemImplToJson(
        _$WalletViewItemImpl instance) =>
    <String, dynamic>{
      'coinId': instance.coinId,
      if (instance.walletId case final value?) 'walletId': value,
    };
