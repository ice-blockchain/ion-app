import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_init_request.g.dart';

@JsonSerializable()
class LoginInitRequest {
  const LoginInitRequest({
    required this.username,
    required this.orgId,
  });

  factory LoginInitRequest.fromJson(JsonObject json) => _$LoginInitRequestFromJson(json);

  final String username;
  final String orgId;

  JsonObject toJson() => _$LoginInitRequestToJson(this);

  @override
  String toString() => 'LoginInitRequest(username: $username, orgId: $orgId)';
}
