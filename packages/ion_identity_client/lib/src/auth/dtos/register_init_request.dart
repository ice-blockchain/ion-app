import 'package:ion_identity_client/src/utils/types.dart';

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
}
