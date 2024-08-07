import 'package:ion_identity_client/src/utils/types.dart';

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
}
