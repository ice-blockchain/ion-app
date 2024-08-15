import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/utils/ion_service_locator.dart';

class IonAuth {
  IonAuth._({
    required this.config,
    required this.dataSource,
    required this.signer,
    required this.tokenStorage,
  });

  factory IonAuth.createDefault({
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return IonAuth._(
      config: config,
      signer: signer,
      dataSource: IonAuthDataSource.createDefault(
        config: config,
      ),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  final IonClientConfig config;
  final IonAuthDataSource dataSource;
  final PasskeysSigner signer;
  final TokenStorage tokenStorage;

  Future<Either<NetworkFailure, RegistrationCompleteResponse>> registerUser({
    required String username,
  }) async {
    return dataSource
        .registerInit(username: username)
        .flatMap(
          (userRegistrationChallenge) => TaskEither.tryCatch(
            () => signer.register(userRegistrationChallenge),
            NetworkFailure.new,
          ).flatMap(
            (attestation) => dataSource.registerComplete(
              attestation: attestation,
              temporaryAuthenticationToken: userRegistrationChallenge.temporaryAuthenticationToken,
            ),
          ),
        )
        .run();
  }

  Future<void> loginUser({
    required String username,
  }) async {
    final response = await dataSource.login(username: username).run();
    response.fold(
      (l) {},
      (r) {
        tokenStorage.setToken(r.token);
      },
    );
  }
}
