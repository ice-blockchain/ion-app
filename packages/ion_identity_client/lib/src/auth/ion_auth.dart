import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/auth/types/register_user_types.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
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

  Future<RegisterUserResult> registerUser({
    required String username,
  }) async {
    final result = await dataSource
        .registerInit(username: username)
        .flatMap(
          (userRegistrationChallenge) => TaskEither<RegisterUserFailure, Fido2Attestation>.tryCatch(
            () => signer.register(userRegistrationChallenge),
            (_, __) => PasskeyValidationRegisterUserFailure(),
          ).flatMap(
            (attestation) => dataSource.registerComplete(
              attestation: attestation,
              temporaryAuthenticationToken: userRegistrationChallenge.temporaryAuthenticationToken,
            ),
          ),
        )
        .run();

    return result.fold(
      (l) => l,
      (r) => RegisterUserSuccess(),
    );
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
