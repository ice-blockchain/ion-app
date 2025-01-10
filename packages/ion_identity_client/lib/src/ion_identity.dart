// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/core/storage/biometrics_state_storage.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/password_signer.dart';

/// This class is an entry point for interacting with the API. Provides user-specific operations
/// such as authentication and wallet management. This client supports multi-user
/// scenarios, allowing different user sessions to be managed concurrently.
class IONIdentity {
  /// Creates an instance of [IONIdentity] with the given [config], [identitySigner], [privateKeyStorage],
  /// and [tokenStorage]. This constructor is private and used internally.
  IONIdentity._({
    required IONIdentityConfig config,
    required IdentitySigner identitySigner,
    required TokenStorage tokenStorage,
    required PrivateKeyStorage privateKeyStorage,
    required BiometricsStateStorage biometricsStateStorage,
  })  : _config = config,
        _identitySigner = identitySigner,
        _tokenStorage = tokenStorage,
        _privateKeyStorage = privateKeyStorage,
        _biometricsStateStorage = biometricsStateStorage;

  /// Factory method to create a default instance of [IONIdentity] using the given [config].
  factory IONIdentity.createDefault({
    required IONIdentityConfig config,
  }) {
    if (!(kIsWeb || Platform.isAndroid || Platform.isIOS)) {
      throw UnimplementedError('Current platform is not supported');
    }

    final tokenStorage = IONIdentityServiceLocator.tokenStorage();
    final privateKeyStorage = IONIdentityServiceLocator.privateKeyStorage();
    final biometricsStateStorage = IONIdentityServiceLocator.biometricsStateStorage();

    final passkeySigner = PasskeysSigner();
    final passwordSigner = PasswordSigner(
      config: config,
      keyService: const KeyService(),
      privateKeyStorage: privateKeyStorage,
      biometricsStateStorage: biometricsStateStorage,
    );
    final identitySigner =
        IdentitySigner(passkeySigner: passkeySigner, passwordSigner: passwordSigner);

    return IONIdentity._(
      config: config,
      identitySigner: identitySigner,
      tokenStorage: tokenStorage,
      privateKeyStorage: privateKeyStorage,
      biometricsStateStorage: biometricsStateStorage,
    );
  }

  Future<void> init() async {
    await Future.wait([
      _tokenStorage.init(),
      _privateKeyStorage.init(),
      _biometricsStateStorage.init(),
    ]);
  }

  void dispose() {
    _tokenStorage.dispose();
    _privateKeyStorage.dispose();
    _biometricsStateStorage.dispose();
  }

  /// Returns a user-specific API client for the given [username].
  /// This allows the caller to perform actions on behalf of the specified user.
  IONIdentityClient call({
    required String username,
  }) {
    return IONIdentityServiceLocator.identityUserClient(
      username: username,
      config: _config,
      identitySigner: _identitySigner,
    );
  }

  Future<void> isPasskeyAuthAvailable() => _identitySigner.isPasskeyAvailable();

  final IONIdentityConfig _config;
  final IdentitySigner _identitySigner;
  final TokenStorage _tokenStorage;
  final PrivateKeyStorage _privateKeyStorage;
  final BiometricsStateStorage _biometricsStateStorage;

  /// A stream of the usernames of currently authorized users. This stream updates
  /// whenever the user tokens change, providing a real-time view of authenticated users.
  Stream<Iterable<String>> get authorizedUsers => _tokenStorage.userTokens.map(
        (tokens) => tokens.map((token) => token.username),
      );

  Stream<Map<String, BiometricsState>> get biometricsStatesStream =>
      _biometricsStateStorage.dataStream;
}
