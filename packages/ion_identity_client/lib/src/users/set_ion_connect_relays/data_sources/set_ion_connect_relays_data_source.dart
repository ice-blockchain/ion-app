// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/identity_storage/identity_storage.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/models/set_ion_connect_relays_request.c.dart';

class SetIONConnectRelaysDataSource {
  SetIONConnectRelaysDataSource(
    this._networkClient,
    this._identityStorage,
  );

  final NetworkClient _networkClient;
  final IdentityStorage _identityStorage;

  static const setUserConnectRelaysPath = '/v1/users';

  Future<SetIONConnectRelaysResponse> setIONConnectRelays({
    required String username,
    required String userId,
    required SetIONConnectRelaysRequest request,
  }) async {
    final token = _identityStorage.getToken(username: username);
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
      decoder: SetIONConnectRelaysResponse.fromJson,
    );

    return response;
  }
}
