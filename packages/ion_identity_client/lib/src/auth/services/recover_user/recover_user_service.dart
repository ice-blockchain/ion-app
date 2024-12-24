// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';

class RecoverUserService {
  RecoverUserService({
    required this.username,
    required this.dataSource,
    required this.config,
    required this.identitySigner,
    required this.keyService,
  });

  final String username;
  final RecoverUserDataSource dataSource;
  final IONIdentityConfig config;
  final IdentitySigner identitySigner;
  final KeyService keyService;

  Future<UserRegistrationChallenge> initRecovery({
    required String credentialId,
    required List<TwoFAType> twoFATypes,
  }) async {
    final userRegistrationChallenge = await dataSource.createDelegatedRecoveryChallenge(
      username: username,
      credentialId: credentialId,
      twoFATypes: twoFATypes,
    );
    return userRegistrationChallenge;
  }

  Future<void> completeRecovery({
    required UserRegistrationChallenge challenge,
    required String credentialId,
    required String recoveryKey,
  }) async {
    final attestation = await identitySigner.registerWithPasskey(challenge);

    final signedRecoveryPackage = await _signNewCredentials(
      encryptedKey: challenge.allowedRecoveryCredentials![0].encryptedRecoveryKey,
      recoveryKey: recoveryKey,
      credentialId: credentialId,
      newCredentials: {
        'firstFactorCredential': attestation.toJson(),
      },
    );

    await dataSource.recoverUser(
      recoveryData: {
        'newCredentials': {
          'firstFactorCredential': attestation.toJson(),
        },
        'recovery': signedRecoveryPackage.toJson(),
      },
      temporaryAuthenticationToken: challenge.temporaryAuthenticationToken!,
    );
  }

  Future<AssertionRequestData> _signNewCredentials({
    required String encryptedKey,
    required String recoveryKey,
    required String credentialId,
    required Map<String, dynamic> newCredentials,
  }) async {
    return identitySigner.signWithPassword(
      challenge: base64UrlEncode(utf8.encode(jsonEncode(newCredentials))),
      encryptedPrivateKey: encryptedKey,
      password: recoveryKey,
      credentialId: credentialId,
      credentialKind: CredentialKind.RecoveryKey,
    );
  }
}
