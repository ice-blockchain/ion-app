import 'package:ion_identity_client/src/utils/types.dart';

class Wallet {
  const Wallet({
    required this.id,
    required this.network,
  });

  factory Wallet.fromJson(JsonObject map) {
    return Wallet(
      id: map['id'] as String,
      network: map['network'] as String,
    );
  }

  final String id;
  final String network;

  JsonObject toJson() {
    return <String, dynamic>{
      'id': id,
      'network': network,
    };
  }

  @override
  String toString() => 'Wallet(id: $id, network: $network)';
}
