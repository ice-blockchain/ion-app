// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/storage/data_storage.dart';
import 'package:ion_identity_client/src/core/types/user_token.f.dart';

class TokenStorage extends DataStorage<Authentication> {
  TokenStorage({
    required super.secureStorage,
  }) : super(
          storageKey: 'ion_identity_client_user_tokens_key',
          fromJson: Authentication.fromJson,
          toJson: (auth) => auth.toJson(),
        );

  Stream<List<UserToken>> get userTokens => dataStream.map((data) {
        return data.entries.map((e) {
          final auth = e.value;
          return UserToken(
            username: e.key,
            token: auth.token,
            refreshToken: auth.refreshToken,
          );
        }).toList();
      });

  UserToken? getToken({required String username}) {
    final auth = super.getData(key: username);
    if (auth == null) return null;
    return UserToken(
      username: username,
      token: auth.token,
      refreshToken: auth.refreshToken,
    );
  }

  Future<void> setToken({
    required String username,
    required String newToken,
  }) async {
    final currentAuth = super.getData(key: username) ?? Authentication.empty();
    final updatedAuth = currentAuth.copyWith(token: newToken);
    await super.setData(key: username, value: updatedAuth);
  }

  Future<void> setTokens({
    required String username,
    required Authentication newTokens,
  }) async {
    await super.setData(key: username, value: newTokens);
  }

  Future<void> removeToken({required String username}) async {
    await super.removeData(key: username);
  }

  Future<void> clearAllTokens() async {
    await super.clearAllData();
  }
}
