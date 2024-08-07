import 'package:ion_identity_client/src/utils/types.dart';

class SupportedCredentialKinds2 {
  SupportedCredentialKinds2(
    this.kind,
    this.factor,
    this.requiresSecondFactor,
  );

  factory SupportedCredentialKinds2.fromJson(JsonObject json) {
    return SupportedCredentialKinds2(
      json['kind'] as String,
      json['factor'] as String,
      json['requiresSecondFactor'] as bool,
    );
  }

  final String kind;
  final String factor;
  final bool requiresSecondFactor;
}
