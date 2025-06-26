// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_signing_key.f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletSigningKeyImpl _$$WalletSigningKeyImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletSigningKeyImpl(
      scheme: json['scheme'] as String,
      curve: json['curve'] as String,
      publicKey: json['publicKey'] as String,
    );

Map<String, dynamic> _$$WalletSigningKeyImplToJson(
        _$WalletSigningKeyImpl instance) =>
    <String, dynamic>{
      'scheme': instance.scheme,
      'curve': instance.curve,
      'publicKey': instance.publicKey,
    };
