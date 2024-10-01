// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  const Wallet({
    required this.id,
    required this.network,
    required this.address,
    required this.name,
  });

  factory Wallet.fromJson(JsonObject map) => _$WalletFromJson(map);

  final String id;
  final String network;
  final String address;
  final String name;

  JsonObject toJson() => _$WalletToJson(this);

  @override
  String toString() => 'Wallet(id: $id, network: $network, address: $address, name: $name)';
}
