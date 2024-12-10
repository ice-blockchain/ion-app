// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/core/identity_storage/identity_storage.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/password_signer.dart';

/// This class is an entry point for interacting with the API. Provides user-specific operations
/// such as authentication and wallet management. This client supports multi-user
/// scenarios, allowing different user sessions to be managed concurrently.
class IONIdentity {
  /// Creates an instance of [IONIdentity] with the given [config], [identitySigner],
  /// and [identityStorage]. This constructor is private and used internally.
  IONIdentity._({
    required IONIdentityConfig config,
    required IdentitySigner identitySigner,
    required IdentityStorage identityStorage,
  })  : _config = config,
        _identitySigner = identitySigner,
        _identityStorage = identityStorage;

  /// Factory method to create a default instance of [IONIdentity] using the given [config].
  factory IONIdentity.createDefault({
    required IONIdentityConfig config,
  }) {
    if (!(kIsWeb || Platform.isAndroid || Platform.isIOS)) {
      throw UnimplementedError('Current platform is not supproted');
    }

    final identityStorage = IONIdentityServiceLocator.identityStorage();
    final passkeySigner = PasskeysSigner();
    final passwordSigner = PasswordSigner(
      config: config,
      keyService: const KeyService(),
      identityStorage: identityStorage,
    );
    final identitySigner =
        IdentitySigner(passkeySigner: passkeySigner, passwordSigner: passwordSigner);

    return IONIdentity._(
      config: config,
      identitySigner: identitySigner,
      identityStorage: identityStorage,
    );
  }

  Future<void> init() async {
    await _identityStorage.init();
  }

  void dispose() {
    _identityStorage.dispose();
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
  final IdentityStorage _identityStorage;

  /// A stream of the usernames of currently authorized users. This stream updates
  /// whenever the user tokens change, providing a real-time view of authenticated users.
  Stream<Iterable<String>> get authorizedUsers => _identityStorage.userTokens.map(
        (tokens) => tokens.map((token) => token.username),
      );
}
