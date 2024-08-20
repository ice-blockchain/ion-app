import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/auth/types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/types/register_user_result.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonAuth {
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

  Future<RegisterUserResult> registerUser() async {
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
      (r) {
        tokenStorage.setToken(
          username: username,
          newToken: r.authentication.token,
        );
        return RegisterUserSuccess();
      },
    );
  }

  Future<LoginUserResult> loginUser() async {
    final response = await dataSource.login(username: username).run();

    return response.fold(
      (l) => l,
      (r) {
        tokenStorage.setToken(
          username: username,
          newToken: r.token,
        );
        return LoginUserSuccess();
      },
    );
  }

  void logOut() {
    // TODO: implement logout request
    tokenStorage.removeToken(username: username);
  }
}
