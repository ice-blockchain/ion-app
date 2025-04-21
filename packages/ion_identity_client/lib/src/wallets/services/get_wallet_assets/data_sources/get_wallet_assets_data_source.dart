// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network/utils.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/wallets/exceptions/wallets_exceptions.dart';
import 'package:sprintf/sprintf.dart';

class GetWalletAssetsDataSource {
  const GetWalletAssetsDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const walletAssetsPath = '/wallets/%s/assets';

  Future<WalletAssets> getWalletAssets(
    String username,
    String walletId,
  ) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      return await _networkClient.get(
        sprintf(walletAssetsPath, [walletId]),
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        decoder: (result) => parseJsonObject(result, fromJson: WalletAssets.fromJson),
      );
    } on NetworkException catch (e) {
      if (e is RequestExecutionException && e.error is DioException) {
        final dioError = e.error as DioException;
        if (dioError.response?.statusCode == 401) {
          throw const UnauthenticatedException();
        }
        if (dioError.response?.statusCode == 404) {
          throw const WalletNotFoundException();
        }
      }
      throw const UnknownIONIdentityException();
    }
  }
}
