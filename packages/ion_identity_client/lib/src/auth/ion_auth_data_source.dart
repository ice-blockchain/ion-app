import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/recovery_key/recovery_key_types.dart';
import 'package:ion_identity_client/src/auth/types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/types/register_user_result.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_signing_complete_request.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

const recoveryKeyBody = {'kind': 'RecoveryKey'};

class IonAuthDataSource {
  IonAuthDataSource({
    required this.config,
    required this.networkClient,
    required this.tokenStorage,
  });

  static const registerInitPath = '/auth/registration/delegated';
  static const registerCompletePath = '/auth/registration/enduser';
  static const loginInitPath = '/auth/login/init';
  static const loginCompletePath = '/auth/login';

  static const createCredentialInitPath = '/auth/credentials/init';
  static const createCredentialPath = '/auth/credentials';

  final IonClientConfig config;
  final NetworkClient networkClient;
  final TokenStorage tokenStorage;

  TaskEither<RegisterUserFailure, UserRegistrationChallenge> registerInit({
    required String username,
  }) {
    final requestData = RegisterInitRequest(email: username);

    return networkClient
        .post(
          registerInitPath,
          data: requestData.toJson(),
          decoder: UserRegistrationChallenge.fromJson,
        )
        .mapLeft(
          (l) => switch (l) {
            ResponseFormatNetworkFailure() => UserAlreadyExistsRegisterUserFailure(),
            _ => const UnknownRegisterUserFailure(),
          },
        );
  }

  TaskEither<RegisterUserFailure, RegistrationCompleteResponse> registerComplete({
    required Fido2Attestation attestation,
    required String temporaryAuthenticationToken,
  }) {
    return networkClient.post(
      registerCompletePath,
      data: SignedChallenge(firstFactorCredential: attestation).toJson(),
      decoder: RegistrationCompleteResponse.fromJson,
      headers: {
        ...RequestHeaders.getAuthorizationHeader(token: temporaryAuthenticationToken),
      },
    ).mapLeft(
      // TODO: find a complete list of user registration failures
      (l) => switch (l) {
        ResponseFormatNetworkFailure() => UserAlreadyExistsRegisterUserFailure(),
        _ => const UnknownRegisterUserFailure(),
      },
    );
  }

  TaskEither<LoginUserFailure, UserActionChallenge> loginInit({
    required String username,
  }) {
    final requestData = LoginInitRequest(username: username);

    return networkClient
        .post(
          loginInitPath,
          data: requestData.toJson(),
          decoder: UserActionChallenge.fromJson,
        )
        .mapLeft(
          (l) => const UnknownLoginUserFailure(),
        );
  }

  TaskEither<LoginUserFailure, Authentication> loginComplete({
    required Fido2Assertion assertion,
    required String challengeIdentifier,
  }) {
    final requestData = UserActionSigningCompleteRequest(
      challengeIdentifier: challengeIdentifier,
      firstFactor: assertion,
    );

    return networkClient
        .post(
          loginCompletePath,
          data: requestData.toJson(),
          decoder: Authentication.fromJson,
        )
        .mapLeft(
          (l) => const UnknownLoginUserFailure(),
        );
  }

  TaskEither<NetworkFailure, CredentialChallenge> createCredentialInit({
    required String username,
  }) {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(RequestExecutionNetworkFailure(401, StackTrace.current));
    }

    return networkClient
        .post(
          createCredentialInitPath,
          data: recoveryKeyBody,
          decoder: CredentialChallenge.fromJson,
          headers: RequestHeaders.getAuthorizationHeader(token: token.token),
        )
        .mapLeft((l) => l);
  }

  UserActionSigningRequest buildCreateCredentialSigningRequest(
    String username,
    CredentialRequestData credentialRequestData,
  ) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: createCredentialPath,
      body: credentialRequestData.toJson(),
    );
  }
}
