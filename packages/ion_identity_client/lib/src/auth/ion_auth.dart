// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials/create_recovery_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/delegated_login_service.dart';
import 'package:ion_identity_client/src/auth/services/login/login_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/recover_user_service.dart';
import 'package:ion_identity_client/src/auth/services/register/register_service.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/users/get_user_details/get_user_details_service.dart';

/// A class that handles user authentication processes, including user registration,
/// login, and logout.
class IonAuth {
  /// Constructs an [IonAuth] instance with the provided services and token storage.
  ///
  /// The [username] is the identifier for the user.
  /// The [registerService] handles user registration.
  /// The [loginService] handles user login.
  /// The [tokenStorage] manages the storage of authentication tokens.
  /// The [createRecoveryCredentialsService] handles the creation of recovery credentials.
  IonAuth({
    required this.username,
    required this.registerService,
    required this.loginService,
    required this.tokenStorage,
    required this.createRecoveryCredentialsService,
    required this.recoverUserService,
    required this.delegatedLoginService,
    required this.getUserService,
  });

  final RegisterService registerService;
  final LoginService loginService;
  final CreateRecoveryCredentialsService createRecoveryCredentialsService;
  final RecoverUserService recoverUserService;
  final DelegatedLoginService delegatedLoginService;
  final GetUserDetailsService getUserService;

  final String username;
  final TokenStorage tokenStorage;

  Future<void> registerUser() => registerService.registerUser();

  Future<void> loginUser() => loginService.loginUser();

  Future<CreateRecoveryCredentialsSuccess> createRecoveryCredentials() =>
      createRecoveryCredentialsService.createRecoveryCredentials();

  Future<void> recoverUser({
    required String credentialId,
    required String recoveryKey,
  }) =>
      recoverUserService.recoverUser(
        credentialId: credentialId,
        recoveryKey: recoveryKey,
      );

  Future<void> logOut() async {
    // TODO: implement logout request
    return tokenStorage.removeToken(username: username);
  }

  Future<UserToken> delegatedLogin() async =>
      delegatedLoginService.delegatedLogin(username: username);
}
