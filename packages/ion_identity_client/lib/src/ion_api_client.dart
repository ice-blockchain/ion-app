import 'dart:io';

import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

/// This class is an entry point for interacting with the API.Provids user-specific operations
/// such as authentication and wallet management. This client supports multi-user
/// scenarios, allowing different user sessions to be managed concurrently.
class IonApiClient {
  /// Creates an instance of [IonApiClient] with the given [config], [signer],
  /// and [tokenStorage]. This constructor is private and used internally.
  IonApiClient._({
    required IonClientConfig config,
    required PasskeysSigner signer,
    required TokenStorage tokenStorage,
  })  : _config = config,
        _signer = signer,
        _tokenStorage = tokenStorage;

  /// Factory method to create a default instance of [IonApiClient] using the given [config].
  factory IonApiClient.createDefault({
    required IonClientConfig config,
  }) {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      throw UnimplementedError('Current platform is not supproted');
    }

    final signer = PasskeysSigner();

    return IonApiClient._(
      config: config,
      signer: signer,
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  /// Returns a user-specific API client for the given [username].
  /// This allows the caller to perform actions on behalf of the specified user.
  IonApiUserClient call({
    required String username,
  }) {
    return IonServiceLocator.getApiClient(
      username: username,
      config: _config,
      signer: _signer,
    );
  }

  final IonClientConfig _config;
  final PasskeysSigner _signer;
  final TokenStorage _tokenStorage;

  /// A stream of the usernames of currently authorized users. This stream updates
  /// whenever the user tokens change, providing a real-time view of authenticated users.
  Stream<Iterable<String>> get authorizedUsers => _tokenStorage.userTokens.map(
        (list) => list.map(
          (e) => e.username,
        ),
      );
}
