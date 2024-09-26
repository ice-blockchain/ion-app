import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supported_credential_kinds.g.dart';

@JsonSerializable()
class SupportedCredentialKinds {
  SupportedCredentialKinds(
    this.firstFactor,
    this.secondFactor,
  );

  factory SupportedCredentialKinds.fromJson(JsonObject json) =>
      _$SupportedCredentialKindsFromJson(json);

  final List<String> firstFactor;
  final List<String> secondFactor;

  @override
  String toString() =>
      'SupportedCredentialKinds(firstFactor: $firstFactor, secondFactor: $secondFactor)';
}
