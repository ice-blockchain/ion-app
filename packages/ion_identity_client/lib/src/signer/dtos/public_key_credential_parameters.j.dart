// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_key_credential_parameters.j.g.dart';

@JsonSerializable()
class PublicKeyCredentialParameters {
  PublicKeyCredentialParameters(
    this.type,
    this.alg,
  );

  factory PublicKeyCredentialParameters.fromJson(JsonObject json) =>
      _$PublicKeyCredentialParametersFromJson(json);

  final String type;
  final int alg;

  JsonObject toJson() => _$PublicKeyCredentialParametersToJson(this);

  @override
  String toString() => 'PublicKeyCredentialParameters(type: $type, alg: $alg)';
}
