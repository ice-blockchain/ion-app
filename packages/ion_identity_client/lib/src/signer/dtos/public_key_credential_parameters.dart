import 'package:ion_identity_client/src/core/types/types.dart';

class PublicKeyCredentialParameters {
  PublicKeyCredentialParameters(
    this.type,
    this.alg,
  );

  factory PublicKeyCredentialParameters.fromJson(JsonObject json) {
    return PublicKeyCredentialParameters(
      json['type'] as String,
      json['alg'] as int,
    );
  }

  final String type;
  final int alg;

  @override
  String toString() => 'PublicKeyCredentialParameters(type: $type, alg: $alg)';
}
