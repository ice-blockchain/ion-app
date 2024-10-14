// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
      id: json['id'] as String,
      network: json['network'] as String,
      status: json['status'] as String,
      signingKey:
          WalletSigningKey.fromJson(json['signingKey'] as Map<String, dynamic>),
      address: json['address'] as String,
      name: json['name'] as String,
      signingKey:
          WalletSigningKey.fromJson(json['signingKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'network': instance.network,
      'status': instance.status,
      'signingKey': instance.signingKey.toJson(),
      'address': instance.address,
      'name': instance.name,
      'signingKey': instance.signingKey.toJson(),
    };

WalletSigningKey _$WalletSigningKeyFromJson(Map<String, dynamic> json) =>
    WalletSigningKey(
      scheme: json['scheme'] as String,
      curve: json['curve'] as String,
      publicKey: json['publicKey'] as String,
    );

Map<String, dynamic> _$WalletSigningKeyToJson(WalletSigningKey instance) =>
    <String, dynamic>{
      'scheme': instance.scheme,
      'curve': instance.curve,
      'publicKey': instance.publicKey,
    };
