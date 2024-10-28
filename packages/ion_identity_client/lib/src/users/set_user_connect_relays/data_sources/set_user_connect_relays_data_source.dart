// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/users/set_user_connect_relays/models/set_user_connect_relays_request.dart';

class SetUserConnectRelaysDataSource {
  SetUserConnectRelaysDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const setUserConnectRelaysPath = '/v1/users';

  Future<SetUserConnectRelaysResponse> setUserConnectRelays({
    required String username,
    required String userId,
    required SetUserConnectRelaysRequest request,
  }) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    final response = await _networkClient.patch(
      '$setUserConnectRelaysPath/$userId/ion-connect-relays',
      data: request.toJson(),
      headers: RequestHeaders.getAuthorizationHeaders(
        username: username,
        token: token.token,
      ),
      decoder: SetUserConnectRelaysResponse.fromJson,
    );

    return response;
  }
}
