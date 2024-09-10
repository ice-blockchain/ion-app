import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/auth/types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/types/register_user_result.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

/// A class that handles user authentication processes, including user registration,
/// login, and logout.
class IonAuth {
  /// Creates an instance of [IonAuth] with the provided [username], [config],
  /// [dataSource], [signer], and [tokenStorage].
  ///
  /// - [username]: The username of the user being authenticated.
  /// - [config]: The client configuration containing necessary identifiers.
  /// - [dataSource]: The data source responsible for API interactions related to authentication.
  /// - [signer]: The passkey signer used for handling cryptographic operations.
  /// - [tokenStorage]: The token storage used to securely manage authentication tokens.
  IonAuth({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.signer,
    required this.tokenStorage,
  });

  final String username;
  final IonClientConfig config;
  final IonAuthDataSource dataSource;
  final PasskeysSigner signer;
  final TokenStorage tokenStorage;

  /// Registers a new user using the provided username and handles the necessary
  /// cryptographic operations and API interactions.
  ///
  /// Returns a [RegisterUserResult], which can either be a [RegisterUserSuccess]
  /// on success or a specific [RegisterUserFailure] type on failure.
  Future<RegisterUserResult> registerUser() async {
    final canAuthenticate = await signer.canAuthenticate();
    if (!canAuthenticate) {
      return const PasskeyNotAvailableRegisterUserFailure();
    }

    final result = await dataSource
        .registerInit(username: username)
        .flatMap(
          (userRegistrationChallenge) => TaskEither<RegisterUserFailure, Fido2Attestation>.tryCatch(
            () => signer.register(userRegistrationChallenge),
            PasskeyValidationRegisterUserFailure.new,
          ).flatMap(
            (attestation) => dataSource.registerComplete(
              attestation: attestation,
              temporaryAuthenticationToken: userRegistrationChallenge.temporaryAuthenticationToken,
            ),
          ),
        )
        .flatMap(
          (r) => tokenStorage.setToken(
            username: username,
            newToken: r.authentication.token,
            onError: UnknownRegisterUserFailure.new,
          ),
        )
        .run();

    return result.fold(
      (l) => l,
      (r) => RegisterUserSuccess(),
    );
  }

  /// Logs in an existing user using the provided username, handling the necessary
  /// API interactions and storing the authentication token securely.
  ///
  /// Returns a [LoginUserResult], which can either be a [LoginUserSuccess] on success
  /// or a specific [LoginUserFailure] type on failure.
  Future<LoginUserResult> loginUser() async {
    final canAuthenticate = await signer.canAuthenticate();
    if (!canAuthenticate) {
      return const PasskeyNotAvailableLoginUserFailure();
    }

    final response = await dataSource
        .loginInit(username: username)
        .flatMap(
          (userActionChallenge) => TaskEither<LoginUserFailure, Fido2Assertion>.tryCatch(
            () => signer.sign(userActionChallenge),
            PasskeyValidationLoginUserFailure.new,
          ).flatMap(
            (assertion) => dataSource.loginComplete(
              assertion: assertion,
              challengeIdentifier: userActionChallenge.challengeIdentifier,
            ),
          ),
        )
        .flatMap(
          (r) => tokenStorage.setToken(
            username: username,
            newToken: r.token,
            onError: UnknownLoginUserFailure.new,
          ),
        )
        .run();

    return response.fold(
      (l) => l,
      (r) => LoginUserSuccess(),
    );
  }

  void logOut() {
    // TODO: implement logout request
    tokenStorage.removeToken(username: username);
  }
}
