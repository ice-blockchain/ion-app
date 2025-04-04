// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoinImpl _$$CoinImplFromJson(Map<String, dynamic> json) => _$CoinImpl(
      contractAddress: json['contractAddress'] as String,
      decimals: (json['decimals'] as num).toInt(),
      iconURL: json['iconURL'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      network: json['network'] as String,
      priceUSD: (json['priceUSD'] as num).toDouble(),
      symbol: json['symbol'] as String,
      symbolGroup: json['symbolGroup'] as String,
      syncFrequency: const SyncFrequencyConverter()
          .fromJson((json['syncFrequency'] as num).toInt()),
    );

Map<String, dynamic> _$$CoinImplToJson(_$CoinImpl instance) =>
    <String, dynamic>{
      'contractAddress': instance.contractAddress,
      'decimals': instance.decimals,
      'iconURL': instance.iconURL,
      'id': instance.id,
      'name': instance.name,
      'network': instance.network,
      'priceUSD': instance.priceUSD,
      'symbol': instance.symbol,
      'symbolGroup': instance.symbolGroup,
      'syncFrequency':
          const SyncFrequencyConverter().toJson(instance.syncFrequency),
    };
