// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/create_credentials/create_new_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/create_credentials/create_recovery_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/delegated_login_service.dart';
import 'package:ion_identity_client/src/auth/services/login/login_service.dart';
import 'package:ion_identity_client/src/auth/services/logout/logout_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/recover_user_service.dart';
import 'package:ion_identity_client/src/auth/services/register/register_service.dart';
import 'package:ion_identity_client/src/auth/services/twofa/twofa_service.dart';
import 'package:ion_identity_client/src/core/storage/biometrics_state_storage.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';

/// A class that handles user authentication processes, including user registration,
/// login, and logout.
class IONIdentityAuth {
  /// Constructs an [IONIdentityAuth] instance with the provided services and token storage.
  ///
  /// The [username] is the identifier for the user.
  /// The [registerService] handles user registration.
  /// The [loginService] handles user login.
  /// The [privateKeyStorage] manages the storage of authentication tokens.
  /// The [createRecoveryCredentialsService] handles the creation of recovery credentials.
  IONIdentityAuth({
    required this.username,
    required this.identitySigner,
    required this.registerService,
    required this.loginService,
    required this.logoutService,
    required this.privateKeyStorage,
    required this.biometricsStateStorage,
    required this.createRecoveryCredentialsService,
    required this.createNewCredentialsService,
    required this.recoverUserService,
    required this.delegatedLoginService,
    required this.twoFAService,
  });

  final RegisterService registerService;
  final IdentitySigner identitySigner;
  final LoginService loginService;
  final LogoutService logoutService;
  final CreateRecoveryCredentialsService createRecoveryCredentialsService;
  final CreateNewCredentialsService createNewCredentialsService;
  final RecoverUserService recoverUserService;
  final DelegatedLoginService delegatedLoginService;
  final TwoFAService twoFAService;
  final PrivateKeyStorage privateKeyStorage;
  final BiometricsStateStorage biometricsStateStorage;

  final String username;

  Future<void> registerUser() => registerService.registerUser();

  Future<void> registerUserWithPassword(String password) =>
      registerService.registerWithPassword(password);

  Future<void> verifyUserLoginFlow() => loginService.verifyUserLoginFlow();

  Future<void> loginUser({
    required OnVerifyIdentity<AssertionRequestData> onVerifyIdentity,
    bool preferImmediatelyAvailableCredentials = false,
  }) =>
      loginService.loginUser(
        onVerifyIdentity: onVerifyIdentity,
        preferImmediatelyAvailableCredentials: preferImmediatelyAvailableCredentials,
      );

  Future<void> logOut() => logoutService.logOut();

  String? getUserPrivateKey() =>
      privateKeyStorage.getPrivateKey(username: username)?.hexEncodedPrivateKeyBytes;

  Future<bool> isPasskeyAvailable() => identitySigner.isPasskeyAvailable();

  bool isPasswordFlowUser() => privateKeyStorage.getPrivateKey(username: username) != null;

  BiometricsState? getBiometricsState() =>
      biometricsStateStorage.getBiometricsState(username: username);

  Future<void> rejectToUseBiometrics() => identitySigner.rejectToUseBiometrics(username);

  Future<void> enrollToUseBiometrics({required String localisedReason}) =>
      identitySigner.enrollToUseBiometrics(
        username: username,
        localisedReason: localisedReason,
      );

  Future<CreateRecoveryCredentialsSuccess> createRecoveryCredentials(
    OnVerifyIdentity<CredentialResponse> onVerifyIdentity,
  ) =>
      createRecoveryCredentialsService.createRecoveryCredentials(onVerifyIdentity);

  Future<void> createNewCredentials(
    OnVerifyIdentity<CredentialRequestData> onVerifyIdentity,
  ) =>
      createNewCredentialsService.createNewCredentials(onVerifyIdentity);

  Future<UserRegistrationChallenge> initRecovery({
    required String credentialId,
    List<TwoFAType> twoFATypes = const [],
  }) =>
      recoverUserService.initRecovery(
        credentialId: credentialId,
        twoFATypes: twoFATypes,
      );

  Future<void> completeRecovery({
    required UserRegistrationChallenge challenge,
    required String credentialId,
    required String recoveryKey,
  }) =>
      recoverUserService.completeRecovery(
        challenge: challenge,
        credentialId: credentialId,
        recoveryKey: recoveryKey,
      );

  Future<UserToken> delegatedLogin() async =>
      delegatedLoginService.delegatedLogin(username: username);

  Future<String?> requestTwoFACode({
    required TwoFAType twoFAType,
    required OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
    Map<String, String>? verificationCodes,
    String? recoveryIdentityKeyName,
  }) =>
      twoFAService.requestTwoFACode(
        twoFAType: twoFAType,
        onVerifyIdentity: onVerifyIdentity,
        verificationCodes: verificationCodes,
        recoveryIdentityKeyName: recoveryIdentityKeyName,
      );

  Future<void> verifyTwoFA(TwoFAType twoFAType) => twoFAService.verifyTwoFA(twoFAType);

  Future<void> deleteTwoFA(
    TwoFAType twoFAType,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity, [
    List<TwoFAType> verificationCodes = const [],
  ]) =>
      twoFAService.deleteTwoFA(twoFAType, onVerifyIdentity, verificationCodes);
}
