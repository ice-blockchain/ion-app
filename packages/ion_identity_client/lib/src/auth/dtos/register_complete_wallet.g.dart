// SPDX-License-Identifier: ice License 1.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_complete_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterCompleteWallet _$RegisterCompleteWalletFromJson(
        Map<String, dynamic> json) =>
    RegisterCompleteWallet(
      network: json['network'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$RegisterCompleteWalletToJson(
        RegisterCompleteWallet instance) =>
    <String, dynamic>{
      'network': instance.network,
      'name': instance.name,
    };
