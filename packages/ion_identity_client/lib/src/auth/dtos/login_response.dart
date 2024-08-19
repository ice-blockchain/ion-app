import 'package:ion_identity_client/src/core/types/types.dart';

class LoginResponse {
  LoginResponse({
    required this.username,
    required this.token,
  });

  factory LoginResponse.fromJson(JsonObject map) {
    return LoginResponse(
      username: map['username'] as String,
      token: map['token'] as String,
    );
  }

  final String username;
  final String token;

  @override
  String toString() => 'LoginResponse(username: $username, token: $token)';
}
