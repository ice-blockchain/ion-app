import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

@JsonSerializable()
class Authentication {
  Authentication({
    required this.token,
  });

  factory Authentication.fromJson(JsonObject map) => _$AuthenticationFromJson(map);

  final String token;

  JsonObject toJson() => _$AuthenticationToJson(this);

  @override
  String toString() => 'Authentication(token: <redacted>)';
}
