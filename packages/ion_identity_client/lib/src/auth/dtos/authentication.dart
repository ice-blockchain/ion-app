import 'package:ion_identity_client/src/core/types/types.dart';

class Authentication {
  Authentication({
    required this.token,
  });

  factory Authentication.fromJson(JsonObject map) {
    return Authentication(
      token: map['token'] as String,
    );
  }

  final String token;

  @override
  String toString() => 'Authentication(token: $token)';
}
