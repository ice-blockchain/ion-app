// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/identity_storage/data_storage.dart';
import 'package:ion_identity_client/src/core/types/user_token.c.dart';
import 'package:rxdart/rxdart.dart';

class IdentityStorage {
  IdentityStorage({
    required FlutterSecureStorage secureStorage,
  })  : _tokenStorage = DataStorage<Authentication>(
          secureStorage: secureStorage,
          storageKey: 'ion_identity_client_user_tokens_key',
          fromJson: Authentication.fromJson,
          toJson: (auth) => auth.toJson(),
        ),
        _privateKeysStorage = DataStorage<String>(
          secureStorage: secureStorage,
          storageKey: 'ion_identity_client_private_keys_key',
          // fromJson: Assuming the stored map looks like {"value": "the_private_key"}
          fromJson: (json) => json['value'] as String,
          // toJson: Convert the string into a map {"value": stringValue}
          toJson: (value) => {'value': value},
        );

  final DataStorage<Authentication> _tokenStorage;
  final DataStorage<String> _privateKeysStorage;

  final BehaviorSubject<List<UserToken>> _userTokensSubject = BehaviorSubject<List<UserToken>>();

  Stream<List<UserToken>> get userTokens => _userTokensSubject.stream;

  /// Initializes both underlying storages.
  Future<void> init() async {
    await Future.wait([
      _tokenStorage.init(),
      _privateKeysStorage.init(),
    ]);
    _emitCurrentTokens();
  }

  UserToken? getToken({required String username}) {
    final auth = _tokenStorage.getData(key: username);
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
    final currentAuth = _tokenStorage.getData(key: username) ?? Authentication.empty();
    final updatedAuth = currentAuth.copyWith(token: newToken);
    await _tokenStorage.setData(key: username, value: updatedAuth);
    _emitCurrentTokens();
  }

  Future<void> setTokens({
    required String username,
    required Authentication newTokens,
  }) async {
    await _tokenStorage.setData(key: username, value: newTokens);
    _emitCurrentTokens();
  }

  Future<void> removeToken({required String username}) async {
    await _tokenStorage.removeData(key: username);
    _emitCurrentTokens();
  }

  Future<void> clearAllTokens() async {
    await _tokenStorage.clearAllData();
    _emitCurrentTokens();
  }

  String? getPrivateKey({required String username}) => _privateKeysStorage.getData(key: username);

  Future<void> setPrivateKey({required String username, required String privateKey}) =>
      _privateKeysStorage.setData(key: username, value: privateKey);

  Future<void> removePrivateKey({required String username}) =>
      _privateKeysStorage.removeData(key: username);

  Future<void> clearAllPrivateKeys() => _privateKeysStorage.clearAllData();

  /// Removes both the user's token and private key.
  Future<void> clearAllUserData({required String username}) async {
    await Future.wait([
      removeToken(username: username),
      removePrivateKey(username: username),
    ]);
  }

  /// Clears all tokens and all private keys.
  Future<void> clearAll() async {
    await Future.wait([
      clearAllTokens(),
      clearAllPrivateKeys(),
    ]);
  }

  void dispose() {
    _userTokensSubject.close();
  }

  void _emitCurrentTokens() {
    final data = _tokenStorage.getAllData();
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
