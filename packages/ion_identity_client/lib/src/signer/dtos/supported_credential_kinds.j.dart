// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supported_credential_kinds.j.g.dart';

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

  JsonObject toJson() => _$SupportedCredentialKindsToJson(this);

  @override
  String toString() =>
      'SupportedCredentialKinds(firstFactor: $firstFactor, secondFactor: $secondFactor)';
}
