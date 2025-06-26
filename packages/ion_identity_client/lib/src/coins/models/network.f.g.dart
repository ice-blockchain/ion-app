// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NetworkImpl _$$NetworkImplFromJson(Map<String, dynamic> json) =>
    _$NetworkImpl(
      displayName: json['displayName'] as String,
      explorerUrl: json['explorerUrl'] as String,
      id: json['id'] as String,
      image: json['image'] as String,
      isTestnet: json['isTestnet'] as bool,
      tier: (json['tier'] as num).toInt(),
    );

Map<String, dynamic> _$$NetworkImplToJson(_$NetworkImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'explorerUrl': instance.explorerUrl,
      'id': instance.id,
      'image': instance.image,
      'isTestnet': instance.isTestnet,
      'tier': instance.tier,
    };
