import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/dtos/login_request.dart';
import 'package:ion_identity_client/src/auth/dtos/login_response.dart';
import 'package:ion_identity_client/src/auth/types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/types/register_user_result.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class IonAuthDataSource {
  IonAuthDataSource({
    required this.config,
    required this.networkClient,
  });

  static const loginInitPath = '/login';
  static const registerInitPath = '/register/init';
  static const registerCompletePath = '/register/complete';

  final IonClientConfig config;
  final NetworkClient networkClient;

  TaskEither<RegisterUserFailure, UserRegistrationChallenge> registerInit({
    required String username,
  }) {
    final requestData = RegisterInitRequest(
      appId: config.appId,
      username: username,
    );

    return networkClient
        .post(
          registerInitPath,
          data: requestData.toJson(),
          decoder: UserRegistrationChallenge.fromJson,
        )
        .mapLeft(
          // TODO: find a complete list of user registration failures
          (l) => switch (l) {
            ResponseFormatNetworkFailure() => UserAlreadyExistsRegisterUserFailure(),
            _ => UnknownRegisterUserFailure(),
          },
        );
  }

  TaskEither<RegisterUserFailure, RegistrationCompleteResponse> registerComplete({
    required Fido2Attestation attestation,
    required String temporaryAuthenticationToken,
  }) {
    final requestData = RegisterCompleteRequest(
      appId: config.appId,
      signedChallenge: SignedChallenge(firstFactorCredential: attestation),
      temporaryAuthenticationToken: temporaryAuthenticationToken,
    );

    return networkClient
        .post(
          registerCompletePath,
          data: requestData.toJson(),
          decoder: RegistrationCompleteResponse.fromJson,
        )
        .mapLeft(
          // TODO: find a complete list of user registration failures
          (l) => switch (l) {
            ResponseFormatNetworkFailure() => UserAlreadyExistsRegisterUserFailure(),
            _ => UnknownRegisterUserFailure(),
          },
        );
  }

  TaskEither<LoginUserFailure, LoginResponse> login({
    required String username,
  }) {
    final requestData = LoginRequest(username: username);

    return networkClient
        .post(
          loginInitPath,
          data: requestData.toJson(),
          decoder: LoginResponse.fromJson,
        )
        .mapLeft(
          (l) => UnknownLoginUserFailure(),
        );
  }
}
