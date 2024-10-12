// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/network2/network_client2.dart';
import 'package:ion_identity_client/src/core/network2/network_exception.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/data_sources/exceptions/exceptions.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/data_sources/models/get_wallets_response.dart';

class GetWalletsDataSource {
  const GetWalletsDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient2 _networkClient;
  final TokenStorage _tokenStorage;

  static const walletsPath = '/wallets';

  Future<List<Wallet>> getWallets(String username) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      final response = await _networkClient.get(
        walletsPath,
        headers: RequestHeaders.getAuthorizationHeader(token: token.token),
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
      throw const UnknownGetWalletsException();
    }
  }
}
