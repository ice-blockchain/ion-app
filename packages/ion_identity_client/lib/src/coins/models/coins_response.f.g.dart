// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coins_response.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoinsResponseImpl _$$CoinsResponseImplFromJson(Map<String, dynamic> json) =>
    _$CoinsResponseImpl(
      coins: (json['coins'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
      networks: (json['networks'] as List<dynamic>)
          .map((e) => Network.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$$CoinsResponseImplToJson(_$CoinsResponseImpl instance) =>
    <String, dynamic>{
      'coins': instance.coins.map((e) => e.toJson()).toList(),
      'networks': instance.networks.map((e) => e.toJson()).toList(),
      'version': instance.version,
    };
