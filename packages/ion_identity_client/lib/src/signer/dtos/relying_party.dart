import 'package:ion_identity_client/src/core/types/types.dart';

class RelyingParty {
  RelyingParty(this.id, this.name);

  factory RelyingParty.fromJson(JsonObject json) {
    return RelyingParty(
      json['id'] as String,
      json['name'] as String,
    );
  }

  final String id;
  final String name;

  @override
  String toString() => 'RelyingParty(id: $id, name: $name)';
}