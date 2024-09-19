import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/auth/recovery_key/recovery_key_service.dart';
import 'package:ion_identity_client/src/auth/types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/types/register_user_result.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/extensions/passkey_signer_extentions.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';

/// A class that handles user authentication processes, including user registration,
/// login, and logout.
class IonAuth {
  /// Creates an instance of [IonAuth] with the provided [username], [config],
  /// [dataSource], [signer], [tokenStorage], [userActionSigner] and [recoveryKeyService].
  ///
  /// - [username]: The username of the user being authenticated.
  /// - [config]: The client configuration containing necessary identifiers.
  /// - [dataSource]: The data source responsible for API interactions related to authentication.
  /// - [signer]: The passkey signer used for handling cryptographic operations.
  /// - [tokenStorage]: The token storage used to securely manage authentication tokens.
  /// - [recoveryKeyManager]: The recovery key manager used for creating recovery keys.
  IonAuth({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.signer,
    required this.tokenStorage,
    required this.userActionSigner,
    required this.recoveryKeyService,
  });

  final String username;
  final IonClientConfig config;
  final IonAuthDataSource dataSource;
  final PasskeysSigner signer;
  final TokenStorage tokenStorage;
  final UserActionSigner userActionSigner;
  final RecoveryKeyService recoveryKeyService;

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

    final response = await signer
        .signChallenge(
          dataSource.loginInit(username: username),
          PasskeyValidationLoginUserFailure.new,
        )
        .flatMap(
          (signedChallenge) => dataSource.loginComplete(
            challengeIdentifier: signedChallenge.userActionChallenge.challengeIdentifier,
            assertion: signedChallenge.assertion,
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

  Future<RecoveryKeyResult> createRecoveryCredentials() async {
    final challengeResponse = await dataSource.createCredentialInit(username: username).run();
    final credentialChallenge = challengeResponse.toNullable()!;

    final recoveryKeyData = await recoveryKeyService.createRecoveryKey(
      challenge: credentialChallenge.challenge,
      origin: config.origin,
    );

    final credentialRequestData = CredentialRequestData(
      challengeIdentifier: credentialChallenge.challengeIdentifier,
      credentialName: recoveryKeyData.name,
      credentialKind: 'RecoveryKey',
      credentialInfo: recoveryKeyData.credentialInfo,
      encryptedPrivateKey: recoveryKeyData.encryptedPrivateKey,
    );

    final request = dataSource.buildCreateCredentialSigningRequest(username, credentialRequestData);
    final result = await userActionSigner.execute(request, CredentialResponse.fromJson).run();

    return result.fold(
      (failure) => RecoveryKeyFailure(failure.toString()),
      (success) => RecoveryKeySuccess(
        recoveryCode: recoveryKeyData.recoveryCode,
        recoveryName: success.name,
        recoveryId: success.credentialId,
      ),
    );
  }

  void logOut() {
    // TODO: implement logout request
    tokenStorage.removeToken(username: username);
  }
}
