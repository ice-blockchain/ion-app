// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_credentials.j.g.dart';

@JsonSerializable()
class RecoveryCredentials {
  const RecoveryCredentials({
    required this.identityKeyName,
    required this.recoveryKeyId,
    required this.recoveryCode,
  });

  factory RecoveryCredentials.fromJson(JsonObject json) => _$RecoveryCredentialsFromJson(json);

  factory RecoveryCredentials.fromStringTuple((String, String, String) tuple) =>
      RecoveryCredentials(
        identityKeyName: tuple.$1,
        recoveryKeyId: tuple.$2,
        recoveryCode: tuple.$3,
      );

  final String identityKeyName;
  final String recoveryKeyId;
  final String recoveryCode;

  JsonObject toJson() => _$RecoveryCredentialsToJson(this);

  (String, String, String) get toStringTuple => (identityKeyName, recoveryKeyId, recoveryCode);
}
