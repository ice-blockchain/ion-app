// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_wallets_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetWalletsResponseImpl _$$GetWalletsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetWalletsResponseImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => Wallet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetWalletsResponseImplToJson(
        _$GetWalletsResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
