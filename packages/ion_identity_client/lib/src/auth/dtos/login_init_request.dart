import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_init_request.g.dart';

@JsonSerializable()
class LoginInitRequest {
  const LoginInitRequest({
    required this.username,
  });

  factory LoginInitRequest.fromJson(JsonObject json) => _$LoginInitRequestFromJson(json);

  final String username;

  JsonObject toJson() => _$LoginInitRequestToJson(this);

  @override
  String toString() => 'LoginInitRequest(username: $username)';
}
