// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/coins/models/coins_response.c.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';

class GetCoinsDataSource {
  GetCoinsDataSource({
    required TokenStorage tokenStorage,
    required NetworkClient networkClient,
  })  : _tokenStorage = tokenStorage,
        _networkClient = networkClient;

  final TokenStorage _tokenStorage;
  final NetworkClient _networkClient;

  Future<CoinsResponse> getCoins({
    required String username,
    required String userId,
    required int currentVersion,
  }) async {
    final token = _tokenStorage.getToken(username: username)?.token;
    if (token == null) {
      throw const UnauthenticatedException();
    }

    final response = await _networkClient.get(
      '/v1/users/$userId/coins',
      queryParams: {
        'version': currentVersion,
      },
      headers: {
        ...RequestHeaders.getAuthorizationHeaders(
          token: token,
          username: username,
        ),
      },
      decoder: (response) {
        if (response.isEmpty) {
          return const CoinsResponse(coins: [], version: 0);
        }

        return CoinsResponse.fromJson(response);
      },
    );
    return response;
  }
}
