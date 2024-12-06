// SPDX-License-Identifier: ice License 1.0
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_signing_complete_request.dart';

class LoginDataSource {
  LoginDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

  static const loginInitPath = '/auth/login/init';
  static const loginCompletePath = '/auth/login';
  static const logoutPath = '/auth/logout';

  Future<SimpleMessageResponse> logout({
    required String username,
    required String token,
  }) async {
    return networkClient.put(
      logoutPath,
      decoder: SimpleMessageResponse.fromJson,
      headers: RequestHeaders.getAuthorizationHeaders(
        token: token,
        username: username,
      ),
    );
  }
  
  Future<UserActionChallenge> loginInit({
    required String username,
  }) async {
    final requestData = LoginInitRequest(username: username);

    return networkClient.post(
      loginInitPath,
      data: requestData.toJson(),
      decoder: UserActionChallenge.fromJson,
    );
  }

  Future<Authentication> loginComplete({
    required Fido2Assertion assertion,
    required String challengeIdentifier,
  }) {
    final requestData = UserActionSigningCompleteRequest(
      challengeIdentifier: challengeIdentifier,
      firstFactor: assertion,
    );

    return networkClient.post(
      loginCompletePath,
      data: requestData.toJson(),
      decoder: Authentication.fromJson,
    );
  }
}
