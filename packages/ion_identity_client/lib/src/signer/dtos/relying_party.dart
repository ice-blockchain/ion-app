import 'package:ion_identity_client/src/utils/types.dart';

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
}
