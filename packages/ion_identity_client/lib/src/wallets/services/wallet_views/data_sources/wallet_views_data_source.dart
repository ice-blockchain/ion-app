// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network/network_exception.dart';
import 'package:ion_identity_client/src/core/network/utils.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/create_wallet_view_request.dart';
import 'package:sprintf/sprintf.dart';

class WalletViewsDataSource {
  const WalletViewsDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const _basePath = '/v1/users/%s/wallet-views';
  static const _specificViewPath = '/v1/users/%s/wallet-views/%s';

  Future<List<WalletView>> getWalletViews(String username, String userId) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      final response = await _networkClient.get(
        sprintf(_basePath, [userId]),
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        decoder: (json) => parseList(json, fromJson: WalletView.fromJson),
      );
      return response;
    } on NetworkException {
      rethrow;
    }
  }

  Future<WalletView> createWalletView(
    String username,
    CreateWalletViewRequest request,
  ) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      return await _networkClient.post(
        sprintf(_basePath, [username]),
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        data: request.toJson(),
        decoder: (json) => parseJsonObject(json, fromJson: WalletView.fromJson),
      );
    } on NetworkException {
      rethrow;
    }
  }

  Future<WalletView> getWalletView(
    String username,
    String viewName,
  ) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      return await _networkClient.get(
        sprintf(_specificViewPath, [username, viewName]),
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        decoder: (json) => parseJsonObject(json, fromJson: WalletView.fromJson),
      );
    } on NetworkException {
      rethrow;
    }
  }

  Future<WalletView> updateWalletView(
    String username,
    String viewName,
    CreateWalletViewRequest request,
  ) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      return await _networkClient.put(
        sprintf(_specificViewPath, [username, viewName]),
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        data: request.toJson(),
        decoder: (json) => parseJsonObject(json, fromJson: WalletView.fromJson),
      );
    } on NetworkException {
      rethrow;
    }
  }

  Future<void> deleteWalletView(
    String username,
    String viewName,
  ) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      await _networkClient.delete(
        sprintf(_specificViewPath, [username, viewName]),
        headers: RequestHeaders.getAuthorizationHeaders(
          token: token.token,
          username: username,
        ),
        decoder: (json) => null,
      );
    } on NetworkException {
      rethrow;
    }
  }
}
