// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/private_key_storage/private_key_storage.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/user_token.c.dart';

/// The IdentityStorage class composes both TokenStorage and PrivateKeysStorage.
/// It exposes their methods, and also provides combined operations.
class IdentityStorage {
  IdentityStorage({
    required FlutterSecureStorage secureStorage,
  })  : _tokenStorage = TokenStorage(secureStorage: secureStorage),
        _privateKeysStorage = PrivateKeysStorage(secureStorage: secureStorage);

  final TokenStorage _tokenStorage;
  final PrivateKeysStorage _privateKeysStorage;

  /// Initializes both underlying storages.
  Future<void> init() async {
    await _tokenStorage.init();
    await _privateKeysStorage.init();
  }

  // Expose TokenStorage methods:
  Stream<List<UserToken>> get userTokens => _tokenStorage.userTokens;

  UserToken? getToken({required String username}) => _tokenStorage.getToken(username: username);

  Future<void> setToken({
    required String username,
    required String newToken,
  }) =>
      _tokenStorage.setToken(username: username, newToken: newToken);

  Future<void> setTokens({
    required String username,
    required Authentication newTokens,
  }) =>
      _tokenStorage.setTokens(username: username, newTokens: newTokens);

  Future<void> removeToken({required String username}) =>
      _tokenStorage.removeToken(username: username);

  Future<void> clearAllTokens() => _tokenStorage.clearAllTokens();

  // Expose PrivateKeysStorage methods:
  Stream<List<PrivateKeyEntry>> get privateKeys => _privateKeysStorage.privateKeys;

  String? getPrivateKey({required String username}) =>
      _privateKeysStorage.getPrivateKey(username: username);

  Future<void> setPrivateKey({required String username, required String privateKey}) =>
      _privateKeysStorage.setPrivateKey(username: username, privateKey: privateKey);

  Future<void> removePrivateKey({required String username}) =>
      _privateKeysStorage.removePrivateKey(username: username);

  Future<void> clearAllPrivateKeys() => _privateKeysStorage.clearAllPrivateKeys();

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

  /// Dispose of both streams to avoid memory leaks.
  void dispose() {
    _tokenStorage.dispose();
    _privateKeysStorage.dispose();
  }
}
