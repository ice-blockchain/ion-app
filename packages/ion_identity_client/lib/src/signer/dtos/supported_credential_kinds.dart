import 'package:ion_identity_client/src/core/types/types.dart';

class SupportedCredentialKinds {
  SupportedCredentialKinds(
    this.firstFactor,
    this.secondFactor,
  );

  factory SupportedCredentialKinds.fromJson(JsonObject json) {
    return SupportedCredentialKinds(
      List<String>.from(json['firstFactor'] as List<dynamic>),
      List<String>.from(json['secondFactor'] as List<dynamic>),
    );
  }

  final List<String> firstFactor;
  final List<String> secondFactor;

  @override
  String toString() =>
      'SupportedCredentialKinds(firstFactor: $firstFactor, secondFactor: $secondFactor)';
}
