import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/ion_service_locator.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/utils/types.dart';

class IonAuthDataSource {
  IonAuthDataSource._({
    required this.config,
    required this.dio,
  });

  factory IonAuthDataSource.createDefault({
    required IonClientConfig config,
  }) {
    final dio = IonServiceLocator.createDio(config: config);

    return IonAuthDataSource._(
      config: config,
      dio: dio,
    );
  }

  static const loginInitPath = '/login';
  static const registerInitPath = '/register/init';
  static const registerCompletePath = '/register/complete';

  final IonClientConfig config;
  final Dio dio;

  Future<UserRegistrationChallenge> registerInit({
    required String username,
  }) async {
    final requestData = RegisterInitRequest(
      appId: config.appId,
      username: username,
    );

    final response = await dio.post<JsonObject>(
      registerInitPath,
      data: requestData.toJson(),
    );

    return UserRegistrationChallenge.fromJson(response.data ?? {});
  }

  Future<RegistrationCompleteResponse> registerComplete({
    required Fido2Attestation attestation,
    required String temporaryAuthenticationToken,
  }) async {
    final requestData = RegisterCompleteRequest(
      appId: config.appId,
      signedChallenge: SignedChallenge(firstFactorCredential: attestation),
      temporaryAuthenticationToken: temporaryAuthenticationToken,
    );

    final response = await dio.post<JsonObject>(
      registerCompletePath,
      data: requestData.toJson(),
    );

    return RegistrationCompleteResponse.fromJson(response.data ?? {});
  }
}
