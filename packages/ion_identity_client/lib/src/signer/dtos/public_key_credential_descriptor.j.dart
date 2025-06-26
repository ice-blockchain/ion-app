// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_key_credential_descriptor.j.g.dart';

@JsonSerializable()
class PublicKeyCredentialDescriptor {
  PublicKeyCredentialDescriptor(
    this.type,
    this.id,
    this.encryptedPrivateKey,
  );

  factory PublicKeyCredentialDescriptor.fromJson(JsonObject json) {
    return _$PublicKeyCredentialDescriptorFromJson(json);
  }

  final String type;
  final String id;
  final String? encryptedPrivateKey;

  JsonObject toJson() => _$PublicKeyCredentialDescriptorToJson(this);
}
