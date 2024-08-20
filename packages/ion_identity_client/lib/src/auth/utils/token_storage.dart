import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/core/types/user_token.dart';

class TokenStorage {
  TokenStorage({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage {
    _loadTokensFromStorage();
    _userTokensStreamController.onListen = () {
      _userTokensStreamController.add(_tokensAsList());
    };
  }

  final FlutterSecureStorage _secureStorage;
  final StreamController<List<UserToken>> _userTokensStreamController =
      StreamController.broadcast();

  Stream<List<UserToken>> get userTokens => _userTokensStreamController.stream;

  final Map<String, String?> _userTokensCache = {};

  static const userTokensKey = 'ion_identity_client_user_tokens_key';

  UserToken? getToken({
    required String username,
  }) {
    final savedToken = _userTokensCache[username];
    if (savedToken == null) {
      return null;
    }

    return UserToken(
      username: username,
      token: savedToken,
    );
  }

  Future<void> setToken({
    required String username,
    required String? newToken,
  }) async {
    _userTokensCache[username] = newToken;
    await _saveTokensToStorage();

    final streamState = _tokensAsList();
    _userTokensStreamController.add(streamState);
  }

  Future<void> removeToken({
    required String username,
  }) async {
    _userTokensCache.remove(username);
    await _saveTokensToStorage();
    _userTokensStreamController.add(_tokensAsList());
  }

  Future<void> clearAllTokens() async {
    _userTokensCache.clear();
    await _saveTokensToStorage();
    _userTokensStreamController.add(_tokensAsList());
  }

  void dispose() {
    _userTokensStreamController.close();
  }

  Future<void> _loadTokensFromStorage() async {
    final tokensJson = await _secureStorage.read(key: userTokensKey);
    if (tokensJson == null) {
      _userTokensStreamController.add([]);
      return;
    }

    final tokensMap = json.decode(tokensJson) as JsonObject;
    _userTokensCache.addAll(Map<String, String?>.from(tokensMap));
    _userTokensStreamController.add(_tokensAsList());
  }

  Future<void> _saveTokensToStorage() async {
    final tokensJson = json.encode(_userTokensCache);
    await _secureStorage.write(key: userTokensKey, value: tokensJson);
  }

  List<UserToken> _tokensAsList() {
    return _userTokensCache.entries
        .map(
          (e) => e.value == null ? null : UserToken(username: e.key, token: e.value!),
        )
        .whereNotNull()
        .toList();
  }
}
