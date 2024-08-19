import 'package:ion_identity_client/src/core/types/types.dart';

class LoginRequest {
  LoginRequest({
    required this.username,
  });

  final String username;

  JsonObject toJson() {
    return {
      'username': username,
    };
  }

  @override
  String toString() => 'LoginRequest(username: $username)';
}
