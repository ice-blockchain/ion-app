// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_action_signing_complete_request.j.g.dart';

@JsonSerializable()
class UserActionSigningCompleteRequest {
  UserActionSigningCompleteRequest({
    required this.challengeIdentifier,
    required this.firstFactor,
  });

  factory UserActionSigningCompleteRequest.fromJson(JsonObject json) =>
      _$UserActionSigningCompleteRequestFromJson(json);

  final String challengeIdentifier;
  final AssertionRequestData firstFactor;

  JsonObject toJson() => _$UserActionSigningCompleteRequestToJson(this);

  @override
  String toString() =>
      'UserActionSigningCompleteRequest(challengeIdentifier: $challengeIdentifier, firstFactor: $firstFactor)';
}
