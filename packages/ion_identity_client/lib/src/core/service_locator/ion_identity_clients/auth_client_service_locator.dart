// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials/create_recovery_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials/data_sources/create_recovery_credentials_data_source.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/data_sources/delegated_login_data_source.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/delegated_login_service.dart';
import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/auth/services/login/data_sources/login_data_source.dart';
import 'package:ion_identity_client/src/auth/services/login/login_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/recover_user_service.dart';
import 'package:ion_identity_client/src/auth/services/register/data_sources/register_data_source.dart';
import 'package:ion_identity_client/src/auth/services/register/register_service.dart';
import 'package:ion_identity_client/src/auth/services/twofa/data_sources/twofa_data_source.dart';
import 'package:ion_identity_client/src/auth/services/twofa/twofa_service.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/user_action_signer_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/wallets_client_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/password_signer.dart';

class AuthClientServiceLocator {
  factory AuthClientServiceLocator() {
    return _instance;
  }

  AuthClientServiceLocator._internal();

  static final AuthClientServiceLocator _instance = AuthClientServiceLocator._internal();

  IONIdentityAuth auth({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
    required PasswordSigner passwordSigner,
  }) {
    return IONIdentityAuth(
      username: username,
      registerService: register(
        username: username,
        config: config,
        signer: signer,
        passwordSigner: passwordSigner,
      ),
      loginService: login(username: username, config: config, signer: signer),
      createRecoveryCredentialsService: createRecoveryCredentials(
        username: username,
        config: config,
        signer: signer,
        passwordSigner: passwordSigner,
      ),
      recoverUserService: recoverUser(
        username: username,
        config: config,
        signer: signer,
      ),
      twoFAService: twoFA(username: username, config: config, signer: signer),
      delegatedLoginService: delegatedLogin(config: config),
      tokenStorage: IONIdentityServiceLocator.tokenStorage(),
    );
  }

  RegisterService register({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
    required PasswordSigner passwordSigner,
  }) {
    return RegisterService(
      username: username,
      signer: signer,
      passwordSigner: passwordSigner,
      dataSource: RegisterDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
      ),
      tokenStorage: IONIdentityServiceLocator.tokenStorage(),
    );
  }

  LoginService login({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return LoginService(
      username: username,
      signer: signer,
      dataSource: LoginDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
      ),
      tokenStorage: IONIdentityServiceLocator.tokenStorage(),
    );
  }

  CreateRecoveryCredentialsService createRecoveryCredentials({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
    required PasswordSigner passwordSigner,
  }) {
    return CreateRecoveryCredentialsService(
      username: username,
      config: config,
      dataSource: CreateRecoveryCredentialsDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
        tokenStorage: IONIdentityServiceLocator.tokenStorage(),
      ),
      userActionSigner: UserActionSignerServiceLocator().userActionSigner(
        config: config,
        signer: signer,
      ),
      passwordSigner: passwordSigner,
      keyService: const KeyService(),
    );
  }

  RecoverUserService recoverUser({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return RecoverUserService(
      config: config,
      username: username,
      passkeySigner: signer,
      dataSource: RecoverUserDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
      ),
      keyService: const KeyService(),
    );
  }

  DelegatedLoginService delegatedLogin({
    required IONIdentityConfig config,
  }) {
    return DelegatedLoginService(
      dataSource: DelegatedLoginDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
        tokenStorage: IONIdentityServiceLocator.tokenStorage(),
      ),
      tokenStorage: IONIdentityServiceLocator.tokenStorage(),
    );
  }

  TwoFAService twoFA({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return TwoFAService(
      username: username,
      dataSource: TwoFADataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
        tokenStorage: IONIdentityServiceLocator.tokenStorage(),
      ),
      wallets: WalletsClientServiceLocator().wallets(
        username: username,
        config: config,
        signer: signer,
      ),
      extractUserIdService: extractUserId(),
    );
  }

  ExtractUserIdService extractUserId() => ExtractUserIdService(
        tokenStorage: IONIdentityServiceLocator.tokenStorage(),
      );
}
