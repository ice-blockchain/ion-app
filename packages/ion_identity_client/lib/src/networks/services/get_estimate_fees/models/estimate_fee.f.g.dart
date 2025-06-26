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
      'estimatedBaseFee': instance.estimatedBaseFee,
      'kind': instance.kind,
      'fast': instance.fast?.toJson(),
      'standard': instance.standard?.toJson(),
      'slow': instance.slow?.toJson(),
    };
