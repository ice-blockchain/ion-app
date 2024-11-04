// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/core/types/user_token.dart';
import 'package:rxdart/rxdart.dart';

/// A class responsible for securely storing and managing user tokens using
/// [FlutterSecureStorage]. It provides methods to set, retrieve, and remove
/// tokens, as well as stream updates to the current list of stored tokens.
class TokenStorage {
  /// Creates an instance of [TokenStorage] with the given [secureStorage].
  /// The constructor initializes the token cache and sets up a stream for
  /// broadcasting token updates.
  TokenStorage({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;
  final BehaviorSubject<List<UserToken>> _userTokensSubject = BehaviorSubject();

  /// A stream of the current list of user tokens. This stream updates whenever
  /// tokens are added, removed, or modified.
  Stream<List<UserToken>> get userTokens => _userTokensSubject.stream;

  final Map<String, Authentication?> _userTokensCache = {};

  /// The key used to store the tokens in secure storage.
  static const userTokensKey = 'ion_identity_client_user_tokens_key';

  Future<void> init() async {
    await _loadTokensFromStorage();
  }

  /// Retrieves the [UserToken] for the specified [username] from the cache.
  /// Returns `null` if no token is found for the given username.
  UserToken? getToken({
    required String username,
  }) {
    final savedToken = _userTokensCache[username];
    if (savedToken == null) {
      return null;
    }

    return UserToken(
      username: username,
      token: savedToken.token,
      refreshToken: savedToken.refreshToken,
    );
  }

  Future<void> setToken({
    required String username,
    required String newToken,
  }) async {
    final currentTokens = _userTokensCache[username];
    final newTokens = currentTokens?.copyWith(token: newToken);
    _userTokensCache[username] = newTokens;

    await _saveTokensToStorage();
    _userTokensSubject.add(_tokensAsList());
  }

  /// Sets a new token for the specified [username] and updates the cache.
  /// If [newToken] is `null`, the existing token is removed.
  /// This method also updates the secure storage and notifies listeners
  /// of the token stream about the change.
  ///
  /// Parameters:
  ///   [username]: The username associated with the token.
  ///   [newToken]: The new token to be set. If null, the token is removed.
  ///
  /// Returns a [Future] that completes when the operation is finished.
  Future<void> setTokens({
    required String username,
    required Authentication newTokens,
  }) async {
    _userTokensCache[username] = newTokens;
    await _saveTokensToStorage();

    _userTokensSubject.add(_tokensAsList());
  }

  /// Removes the token associated with the specified [username] from the cache
  /// and updates the storage and token stream.
  Future<void> removeToken({
    required String username,
  }) async {
    _userTokensCache.remove(username);
    await _saveTokensToStorage();
    _userTokensSubject.add(_tokensAsList());
  }

  /// Clears all stored tokens from the cache, updates the storage, and emits
  /// an empty list to the token stream.
  Future<void> clearAllTokens() async {
    _userTokensCache.clear();
    await _saveTokensToStorage();
    _userTokensSubject.add(_tokensAsList());
  }

  /// Disposes of the stream controller, closing the stream to prevent memory leaks.
  void dispose() {
    _userTokensSubject.close();
  }

  /// Loads the tokens from secure storage into the in-memory cache and
  /// updates the token stream with the current list of tokens.
  Future<void> _loadTokensFromStorage() async {
    final tokensJson = await _secureStorage.read(key: userTokensKey);
    if (tokensJson == null) {
      _userTokensSubject.add([]);
      return;
    }

    final tokensMap = json.decode(tokensJson) as JsonObject;
    _userTokensCache.addAll(
      Map<String, Authentication?>.from(
        tokensMap.map(
          (key, value) => MapEntry(
            key,
            value == null ? Authentication.empty() : Authentication.fromJson(value as JsonObject),
          ),
        ),
      ),
    );
    _userTokensSubject.add(_tokensAsList());
  }

  /// Saves the current token cache to secure storage, serializing it as a JSON object.
  Future<void> _saveTokensToStorage() async {
    final tokensJson = json.encode(
      _userTokensCache.map(
        (key, value) => MapEntry(
          key,
          value?.toJson(),
        ),
      ),
    );
    await _secureStorage.write(key: userTokensKey, value: tokensJson);
  }

  /// Converts the in-memory token cache to a list of [UserToken] objects,
  /// filtering out any entries with `null` tokens.
  List<UserToken> _tokensAsList() {
    return _userTokensCache.entries
        .map(
          (e) => e.value == null
              ? null
              : UserToken(
                  username: e.key,
                  token: e.value!.token,
                  refreshToken: e.value!.refreshToken,
                ),
        )
        .whereNotNull()
        .toList();
  }
}
