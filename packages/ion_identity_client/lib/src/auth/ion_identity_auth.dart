// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials/create_recovery_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/delegated_login_service.dart';
import 'package:ion_identity_client/src/auth/services/login/login_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/recover_user_service.dart';
import 'package:ion_identity_client/src/auth/services/register/register_service.dart';
import 'package:ion_identity_client/src/auth/services/twofa/twofa_service.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';

/// A class that handles user authentication processes, including user registration,
/// login, and logout.
class IONIdentityAuth {
  /// Constructs an [IONIdentityAuth] instance with the provided services and token storage.
  ///
  /// The [username] is the identifier for the user.
  /// The [registerService] handles user registration.
  /// The [loginService] handles user login.
  /// The [tokenStorage] manages the storage of authentication tokens.
  /// The [createRecoveryCredentialsService] handles the creation of recovery credentials.
  IONIdentityAuth({
    required this.username,
    required this.registerService,
    required this.loginService,
    required this.tokenStorage,
    required this.createRecoveryCredentialsService,
    required this.recoverUserService,
    required this.delegatedLoginService,
    required this.twoFAService,
  });

  final RegisterService registerService;
  final LoginService loginService;
  final CreateRecoveryCredentialsService createRecoveryCredentialsService;
  final RecoverUserService recoverUserService;
  final DelegatedLoginService delegatedLoginService;
  final TwoFAService twoFAService;

  final String username;
  final TokenStorage tokenStorage;

  Future<void> registerUser() => registerService.registerUser();

  Future<void> loginUser() => loginService.loginUser();

  Future<CreateRecoveryCredentialsSuccess> createRecoveryCredentials() =>
      createRecoveryCredentialsService.createRecoveryCredentials();

  Future<void> recoverUser({
    required String credentialId,
    required String recoveryKey,
    List<TwoFAType> twoFATypes = const [],
  }) =>
      recoverUserService.recoverUser(
        credentialId: credentialId,
        recoveryKey: recoveryKey,
        twoFATypes: twoFATypes,
      );

  Future<void> logOut() async {
    // TODO: implement logout request
    return tokenStorage.removeToken(username: username);
  }

  Future<UserToken> delegatedLogin() async =>
      delegatedLoginService.delegatedLogin(username: username);

  Future<String?> requestTwoFACode({
    required TwoFAType twoFAType,
    Map<String, String>? verificationCodes,
    String? recoveryIdentityKeyName,
  }) =>
      twoFAService.requestTwoFACode(
        twoFAType: twoFAType,
        verificationCodes: verificationCodes,
        recoveryIdentityKeyName: recoveryIdentityKeyName,
      );

  Future<void> verifyTwoFA(TwoFAType twoFAType) => twoFAService.verifyTwoFA(twoFAType);

  Future<void> deleteTwoFA(
    TwoFAType twoFAType, [
    List<TwoFAType> verificationCodes = const [],
  ]) =>
      twoFAService.deleteTwoFA(twoFAType, verificationCodes);
}
