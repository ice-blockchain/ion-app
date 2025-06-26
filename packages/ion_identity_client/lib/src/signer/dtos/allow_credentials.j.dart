// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/public_key_credential_descriptor.j.dart';
import 'package:json_annotation/json_annotation.dart';

part 'allow_credentials.j.g.dart';

@JsonSerializable()
class AllowCredentials {
  AllowCredentials(
    this.webauthn,
    this.key,
    this.passwordProtectedKey,
  );

  factory AllowCredentials.fromJson(JsonObject json) {
    return _$AllowCredentialsFromJson(json);
  }

  final List<PublicKeyCredentialDescriptor> webauthn;
  final List<PublicKeyCredentialDescriptor> key;
  final List<PublicKeyCredentialDescriptor>? passwordProtectedKey;

  JsonObject toJson() => _$AllowCredentialsToJson(this);
}
