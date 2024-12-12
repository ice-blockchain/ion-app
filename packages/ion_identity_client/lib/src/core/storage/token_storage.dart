// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/storage/data_storage.dart';
import 'package:ion_identity_client/src/core/types/user_token.c.dart';
import 'package:rxdart/rxdart.dart';

class TokenStorage extends DataStorage<Authentication> {
  TokenStorage({
    required super.secureStorage,
  }) : super(
          storageKey: 'ion_identity_client_user_tokens_key',
          fromJson: Authentication.fromJson,
          toJson: (auth) => auth.toJson(),
        );

  final BehaviorSubject<List<UserToken>> _userTokensSubject = BehaviorSubject<List<UserToken>>();

  Stream<List<UserToken>> get userTokens => _userTokensSubject.stream;

  @override
  Future<void> init() async {
    await super.init();
    _emitCurrentTokens();
  }

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
    _emitCurrentTokens();
  }

  Future<void> setTokens({
    required String username,
    required Authentication newTokens,
  }) async {
    await super.setData(key: username, value: newTokens);
    _emitCurrentTokens();
  }

  Future<void> removeToken({required String username}) async {
    await super.removeData(key: username);
    _emitCurrentTokens();
  }

  Future<void> clearAllTokens() async {
    await super.clearAllData();
    _emitCurrentTokens();
  }

  void dispose() {
    _userTokensSubject.close();
  }

  void _emitCurrentTokens() {
    final data = super.getAllData();
    final tokensList = data.entries.map((e) {
      final auth = e.value;
      return UserToken(
        username: e.key,
        token: auth.token,
        refreshToken: auth.refreshToken,
      );
    }).toList();

    _userTokensSubject.add(tokensList);
  }
}
