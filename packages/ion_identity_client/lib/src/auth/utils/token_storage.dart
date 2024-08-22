import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/core/types/user_token.dart';

/// A class responsible for securely storing and managing user tokens using
/// [FlutterSecureStorage]. It provides methods to set, retrieve, and remove
/// tokens, as well as stream updates to the current list of stored tokens.
class TokenStorage {
  /// Creates an instance of [TokenStorage] with the given [secureStorage].
  /// The constructor initializes the token cache and sets up a stream for
  /// broadcasting token updates.
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

  /// A stream of the current list of user tokens. This stream updates whenever
  /// tokens are added, removed, or modified.
  Stream<List<UserToken>> get userTokens => _userTokensStreamController.stream;

  final Map<String, String?> _userTokensCache = {};

  /// The key used to store the tokens in secure storage.
  static const userTokensKey = 'ion_identity_client_user_tokens_key';

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
      token: savedToken,
    );
  }

  /// Sets a new token for the specified [username] and updates the cache.
  /// If [newToken] is `null`, the existing token is removed. The [onError]
  /// callback is used to handle any errors that occur during the operation.
  /// Returns a [TaskEither] that either contains an error of type [E] or
  /// a unit value indicating success.
  TaskEither<E, Unit> setToken<E>({
    required String username,
    required String? newToken,
    required E Function(Object?, StackTrace?) onError,
  }) {
    return TaskEither<E, Unit>.tryCatch(
      () async {
        _userTokensCache[username] = newToken;
        await _saveTokensToStorage();

        final streamState = _tokensAsList();
        _userTokensStreamController.add(streamState);
        return unit;
      },
      onError,
    );
  }

  /// Removes the token associated with the specified [username] from the cache
  /// and updates the storage and token stream.
  Future<void> removeToken({
    required String username,
  }) async {
    _userTokensCache.remove(username);
    await _saveTokensToStorage();
    _userTokensStreamController.add(_tokensAsList());
  }

  /// Clears all stored tokens from the cache, updates the storage, and emits
  /// an empty list to the token stream.
  Future<void> clearAllTokens() async {
    _userTokensCache.clear();
    await _saveTokensToStorage();
    _userTokensStreamController.add(_tokensAsList());
  }

  /// Disposes of the stream controller, closing the stream to prevent memory leaks.
  void dispose() {
    _userTokensStreamController.close();
  }

  /// Loads the tokens from secure storage into the in-memory cache and
  /// updates the token stream with the current list of tokens.
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

  /// Saves the current token cache to secure storage, serializing it as a JSON object.
  Future<void> _saveTokensToStorage() async {
    final tokensJson = json.encode(_userTokensCache);
    await _secureStorage.write(key: userTokensKey, value: tokensJson);
  }

  /// Converts the in-memory token cache to a list of [UserToken] objects,
  /// filtering out any entries with `null` tokens.
  List<UserToken> _tokensAsList() {
    return _userTokensCache.entries
        .map(
          (e) => e.value == null ? null : UserToken(username: e.key, token: e.value!),
        )
        .whereNotNull()
        .toList();
  }
}
