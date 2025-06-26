// SPDX-License-Identifier: ice License 1.0

import 'package:json_annotation/json_annotation.dart';

part 'register_complete_wallet.j.g.dart';

@JsonSerializable()
class RegisterCompleteWallet {
  const RegisterCompleteWallet({
    required this.network,
    required this.name,
  });

  factory RegisterCompleteWallet.fromJson(Map<String, dynamic> json) =>
      _$RegisterCompleteWalletFromJson(json);

  final String network;
  final String name;

  Map<String, dynamic> toJson() => _$RegisterCompleteWalletToJson(this);

  @override
  String toString() => 'RegisterCompleteWallet(network: $network, name: $name)';
}
