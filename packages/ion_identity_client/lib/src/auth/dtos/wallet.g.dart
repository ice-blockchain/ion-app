// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'] as String,
      network: json['network'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'network': instance.network,
      'address': instance.address,
      'name': instance.name,
    };
