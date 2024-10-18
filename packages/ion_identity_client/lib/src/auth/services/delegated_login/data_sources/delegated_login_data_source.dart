// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/models/delegated_login_request.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/models/delegated_login_response.dart';
import 'package:ion_identity_client/src/core/network2/network_client2.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';

class DelegatedLoginDataSource {
  DelegatedLoginDataSource({
    required this.networkClient,
    required this.tokenStorage,
  });

  final NetworkClient2 networkClient;
  final TokenStorage tokenStorage;

  static const delegatedLoginPath = '/auth/login/delegated';

  Future<String> delegatedLogin({
    required String username,
  }) async {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    final requestData = DelegatedLoginRequest(username: username);
    final response = await networkClient.post(
      delegatedLoginPath,
      headers: RequestHeaders.getAuthorizationHeader(token: token.token),
      data: requestData.toJson(),
      decoder: DelegatedLoginResponse.fromJson,
    );
    return response.token;
  }
}
