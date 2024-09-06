import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_complete_request.g.dart';

@JsonSerializable()
class LoginCompleteRequest {
  LoginCompleteRequest({
    required this.challengeIdentifier,
    required this.firstFactor,
  });

  factory LoginCompleteRequest.fromJson(JsonObject json) => _$LoginCompleteRequestFromJson(json);

  final String challengeIdentifier;
  final Fido2Assertion firstFactor;

  JsonObject toJson() => _$LoginCompleteRequestToJson(this);

  @override
  String toString() =>
      'LoginCompleteRequest(challengeIdentifier: $challengeIdentifier, firstFactor: $firstFactor)';
}
