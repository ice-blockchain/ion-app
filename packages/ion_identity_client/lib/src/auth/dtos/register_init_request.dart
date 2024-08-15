import 'package:ion_identity_client/src/core/types/types.dart';

class RegisterInitRequest {
  RegisterInitRequest({
    required this.appId,
    required this.username,
  });

  final String appId;
  final String username;

  JsonObject toJson() {
    return {
      'appId': appId,
      'username': username,
    };
  }

  @override
  String toString() => 'RegisterInitRequest(appId: $appId, username: $username)';
}
