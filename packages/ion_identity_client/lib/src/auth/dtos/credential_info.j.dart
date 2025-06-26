// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_info.j.g.dart';

@JsonSerializable()
class CredentialInfo {
  const CredentialInfo({
    required this.credId,
    required this.clientData,
    required this.attestationData,
  });

  factory CredentialInfo.fromJson(JsonObject json) => _$CredentialInfoFromJson(json);

  final String credId;
  final String clientData;
  final String attestationData;

  JsonObject toJson() => _$CredentialInfoToJson(this);

  @override
  String toString() =>
      'CredentialInfo(credId: $credId, clientData: $clientData, attestationData: $attestationData)';
}
