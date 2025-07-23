// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimate_fee.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EstimateFeeImpl _$$EstimateFeeImplFromJson(Map<String, dynamic> json) =>
    _$EstimateFeeImpl(
      network: json['network'] as String,
      estimatedBaseFee: (json['estimatedBaseFee'] as num?)?.toInt(),
      kind: json['kind'] as String?,
      fast: json['fast'] == null
          ? null
          : NetworkFee.fromJson(json['fast'] as Map<String, dynamic>),
      standard: json['standard'] == null
          ? null
          : NetworkFee.fromJson(json['standard'] as Map<String, dynamic>),
      slow: json['slow'] == null
          ? null
          : NetworkFee.fromJson(json['slow'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EstimateFeeImplToJson(_$EstimateFeeImpl instance) =>
    <String, dynamic>{
      'network': instance.network,
      if (instance.estimatedBaseFee case final value?)
        'estimatedBaseFee': value,
      if (instance.kind case final value?) 'kind': value,
      if (instance.fast?.toJson() case final value?) 'fast': value,
      if (instance.standard?.toJson() case final value?) 'standard': value,
      if (instance.slow?.toJson() case final value?) 'slow': value,
    };
