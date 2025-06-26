// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'allowed_recovery_credential.j.g.dart';

@JsonSerializable()
class AllowedRecoveryCredential {
  AllowedRecoveryCredential(
    this.id,
    this.encryptedRecoveryKey,
  );

  factory AllowedRecoveryCredential.fromJson(JsonObject json) =>
      _$AllowedRecoveryCredentialFromJson(json);

  final String id;
  final String encryptedRecoveryKey;

  @override
  String toString() =>
      'AllowedRecoveryCredential(id: $id, encryptedRecoveryKey: $encryptedRecoveryKey)';
}
