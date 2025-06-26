// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_response.j.g.dart';

@JsonSerializable()
class CredentialResponse {
  const CredentialResponse({
    required this.credentialUuid,
    required this.credentialId,
    required this.dateCreated,
    required this.isActive,
    required this.kind,
    required this.name,
    required this.origin,
    required this.relyingPartyId,
    required this.publicKey,
  });

  factory CredentialResponse.fromJson(JsonObject json) => _$CredentialResponseFromJson(json);

  final String credentialUuid;
  final String credentialId;
  final DateTime dateCreated;
  final bool isActive;
  final String kind;
  final String name;
  final String origin;
  final String relyingPartyId;
  final String publicKey;
}
