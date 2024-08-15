import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/dtos/login_request.dart';
import 'package:ion_identity_client/src/auth/dtos/login_response.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/utils/ion_service_locator.dart';

class IonAuthDataSource {
  IonAuthDataSource._({
    required this.config,
    required this.networkClient,
  });

  factory IonAuthDataSource.createDefault({
    required IonClientConfig config,
  }) {
    final networkClient = IonServiceLocator.getNetworkClient(config: config);

    return IonAuthDataSource._(
      config: config,
      networkClient: networkClient,
    );
  }

  static const loginInitPath = '/login';
  static const registerInitPath = '/register/init';
  static const registerCompletePath = '/register/complete';

  final IonClientConfig config;
  final NetworkClient networkClient;

  TaskEither<NetworkFailure, UserRegistrationChallenge> registerInit({
    required String username,
  }) {
    final requestData = RegisterInitRequest(
      appId: config.appId,
      username: username,
    );

    return networkClient.post(
      registerInitPath,
      data: requestData.toJson(),
      decoder: (response) => UserRegistrationChallenge.fromJson(response.data ?? {}),
    );
  }

  TaskEither<NetworkFailure, RegistrationCompleteResponse> registerComplete({
    required Fido2Attestation attestation,
    required String temporaryAuthenticationToken,
  }) {
    final requestData = RegisterCompleteRequest(
      appId: config.appId,
      signedChallenge: SignedChallenge(firstFactorCredential: attestation),
      temporaryAuthenticationToken: temporaryAuthenticationToken,
    );

    return networkClient.post(
      registerCompletePath,
      data: requestData.toJson(),
      decoder: (response) => RegistrationCompleteResponse.fromJson(response.data ?? {}),
    );
  }

  TaskEither<NetworkFailure, LoginResponse> login({
    required String username,
  }) {
    final requestData = LoginRequest(username: username);

    return networkClient.post(
      loginInitPath,
      data: requestData.toJson(),
      decoder: (response) => LoginResponse.fromJson(response.data ?? {}),
    );
  }
}
