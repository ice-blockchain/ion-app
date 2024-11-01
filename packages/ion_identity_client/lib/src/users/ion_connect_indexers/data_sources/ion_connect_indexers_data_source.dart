// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';

class IonConnectIndexersDataSource {
  IonConnectIndexersDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const getUserConnectIndexersPath = '/v1/users';

  Future<List<String>> fetchIonConnectIndexers({
    required String username,
    required String userId,
  }) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    final response = await _networkClient.get(
      '$getUserConnectIndexersPath/$userId/ion-connect-indexers',
      headers: RequestHeaders.getAuthorizationHeaders(
        username: username,
        token: token.token,
      ),
      decoder: IonConnectIndexersResponse.fromJson,
    );

    return response.ionConnectIndexers;
  }
}
