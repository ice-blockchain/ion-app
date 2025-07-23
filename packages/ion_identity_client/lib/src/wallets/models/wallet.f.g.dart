// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
      id: json['id'] as String,
      network: json['network'] as String,
      status: json['status'] as String?,
      signingKey:
          WalletSigningKey.fromJson(json['signingKey'] as Map<String, dynamic>),
      address: json['address'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'network': instance.network,
      if (instance.status case final value?) 'status': value,
      'signingKey': instance.signingKey.toJson(),
      if (instance.address case final value?) 'address': value,
      if (instance.name case final value?) 'name': value,
    };
