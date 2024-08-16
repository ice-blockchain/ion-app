import 'package:ion_identity_client/src/utils/types.dart';

class Credential {
  Credential({
    required this.uuid,
    required this.kind,
    required this.name,
  });

  factory Credential.fromJson(JsonObject map) {
    return Credential(
      uuid: map['uuid'] as String,
      kind: map['kind'] as String,
      name: map['name'] as String,
    );
  }

  final String uuid;
  final String kind;
  final String name;

  @override
  String toString() => 'Credential(uuid: $uuid, kind: $kind, name: $name)';
}
