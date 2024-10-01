// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supported_credential_kinds_2.g.dart';

@JsonSerializable()
class SupportedCredentialKinds2 {
  SupportedCredentialKinds2(
    this.kind,
    this.factor,
    this.requiresSecondFactor,
  );

  factory SupportedCredentialKinds2.fromJson(JsonObject json) {
    return _$SupportedCredentialKinds2FromJson(json);
  }

  final String kind;
  final String factor;
  final bool requiresSecondFactor;

  JsonObject toJson() => _$SupportedCredentialKinds2ToJson(this);
}
