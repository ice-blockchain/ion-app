// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/identity_storage/identity_storage.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network/network_exception.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/models/get_wallets_response.c.dart';

class GetWalletsDataSource {
  const GetWalletsDataSource(
    this._networkClient,
    this._identityStorage,
  );

  final NetworkClient _networkClient;
  final IdentityStorage _identityStorage;

  static const walletsPath = '/wallets';

  Future<List<Wallet>> getWallets(String username) async {
    final token = _identityStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      final response = await _networkClient.get(
        walletsPath,
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        decoder: GetWalletsResponse.fromJson,
      );
      return response.items;
    } on NetworkException catch (e) {
      if (e is RequestExecutionException && e.error is DioException) {
        final dioError = e.error as DioException;
        if (dioError.response?.statusCode == 401) {
          throw const UnauthenticatedException();
        }
      }
      rethrow;
    }
  }
}
