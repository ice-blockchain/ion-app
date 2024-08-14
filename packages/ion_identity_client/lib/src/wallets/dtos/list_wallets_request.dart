import 'package:ion_identity_client/src/utils/types.dart';

class ListWalletsRequest {
  ListWalletsRequest({
    required this.appId,
    required this.authToken,
  });

  final String appId;
  final String authToken;

  JsonObject toJson() {
    return {
      'appId': appId,
      'authToken': authToken,
    };
  }

  @override
  String toString() => 'ListWalletsRequest(appId: $appId, authToken: $authToken)';
}
