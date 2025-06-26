// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authenticator_selection_criteria.j.g.dart';

@JsonSerializable()
class AuthenticatorSelectionCriteria {
  AuthenticatorSelectionCriteria(
    this.authenticatorAttachment,
    this.residentKey,
    this.requireResidentKey,
    this.userVerification,
  );

  factory AuthenticatorSelectionCriteria.fromJson(JsonObject json) =>
      _$AuthenticatorSelectionCriteriaFromJson(json);

  final String? authenticatorAttachment;
  final String residentKey;
  final bool requireResidentKey;
  final String userVerification;

  JsonObject toJson() => _$AuthenticatorSelectionCriteriaToJson(this);

  @override
  String toString() {
    return 'AuthenticatorSelectionCriteria(authenticatorAttachment: $authenticatorAttachment, residentKey: $residentKey, requireResidentKey: $requireResidentKey, userVerification: $userVerification)';
  }
}
