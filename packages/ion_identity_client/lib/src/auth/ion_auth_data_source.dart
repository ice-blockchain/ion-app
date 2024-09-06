import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/types/register_user_result.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class IonAuthDataSource {
  IonAuthDataSource({
    required this.config,
    required this.networkClient,
  });

  static const registerInitPath = '/auth/registration/delegated';
  static const registerCompletePath = '/auth/registration/enduser';
  static const loginInitPath = '/auth/login/init';
  static const loginCompletePath = '/auth/login';

  final IonClientConfig config;
  final NetworkClient networkClient;

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
    final requestData = LoginInitRequest(
      username: username,
      orgId: config.orgId,
    );

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
    final requestData = LoginCompleteRequest(
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
}
