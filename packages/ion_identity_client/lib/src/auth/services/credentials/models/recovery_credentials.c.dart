// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_credentials.c.g.dart';

@JsonSerializable()
class RecoveryCredentials {
  const RecoveryCredentials({
    required this.identityKeyName,
    required this.recoveryKeyId,
    required this.recoveryCode,
  });

  factory RecoveryCredentials.fromJson(JsonObject json) => _$RecoveryCredentialsFromJson(json);

  final String identityKeyName;
  final String recoveryKeyId;
  final String recoveryCode;

  JsonObject toJson() => _$RecoveryCredentialsToJson(this);
}
