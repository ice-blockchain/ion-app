// SPDX-License-Identifier: ice License 1.0
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class LogoutDataSource {
  LogoutDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

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
}
