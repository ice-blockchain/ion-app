// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/credentials/data_sources/create_recovery_credentials_data_source.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:uuid/uuid.dart';

class CreateRecoveryCredentialsService {
  CreateRecoveryCredentialsService({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.userActionSigner,
    required this.identitySigner,
    required this.keyService,
  });

  final String username;
  final IONIdentityConfig config;
  final CreateRecoveryCredentialsDataSource dataSource;
  final UserActionSigner userActionSigner;
  final IdentitySigner identitySigner;
  final KeyService keyService;

  Future<RecoveryCredentials> createRecoveryCredentials(
    OnVerifyIdentity<CredentialResponse> onVerifyIdentity,
  ) async {
    final credentialChallenge = await dataSource.createCredentialInit(username: username);
    final recoveryCode = generateRecoveryCode();
    final credentialRequestData = await identitySigner.registerWithPassword(
      challenge: credentialChallenge.challenge,
      password: recoveryCode,
      username: username,
      credentialKind: CredentialKind.RecoveryKey,
    );

    final credentialRequest = dataSource.buildCreateCredentialSigningRequest(
      username,
      CredentialRequestData(
        challengeIdentifier: credentialChallenge.challengeIdentifier,
        credentialName: generateCredentialName(),
        credentialKind: credentialRequestData.credentialKind,
        credentialInfo: credentialRequestData.credentialInfo,
        encryptedPrivateKey: credentialRequestData.encryptedPrivateKey,
      ),
    );

    final credentialResponse = await onVerifyIdentity(
      onPasswordFlow: ({required String password}) {
        return userActionSigner.signWithPassword(
          credentialRequest,
          CredentialResponse.fromJson,
          password,
        );
      },
      onPasskeyFlow: () {
        return userActionSigner.signWithPasskey(
          credentialRequest,
          CredentialResponse.fromJson,
        );
      },
      onBiometricsFlow: ({required String localisedReason, required String localisedCancel}) {
        return userActionSigner.signWithBiometrics(
          credentialRequest,
          CredentialResponse.fromJson,
          localisedReason,
          localisedCancel,
        );
      },
    );

    return RecoveryCredentials(
      identityKeyName: username,
      recoveryCode: recoveryCode,
      recoveryKeyId: credentialResponse.credentialId,
    );
  }

  String generateCredentialName() => const Uuid().v4().toUpperCase();

  String generateRecoveryCode() {
    const length = 32;

    const digits = '0123456789';
    const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const symbols = r'@%!$#';

    // Combine all character sets
    const allChars = digits + lowerCaseLetters + upperCaseLetters + symbols;

    final rand = Random.secure();

    // Ensure recovery code includes at least one character from each category
    final recoveryCodeChars = <String>[
      digits[rand.nextInt(digits.length)],
      lowerCaseLetters[rand.nextInt(lowerCaseLetters.length)],
      upperCaseLetters[rand.nextInt(upperCaseLetters.length)],
      symbols[rand.nextInt(symbols.length)],
    ];

    // Fill the rest of the recovery code length with random characters from allChars
    for (var i = 4; i < length; i++) {
      recoveryCodeChars.add(allChars[rand.nextInt(allChars.length)]);
    }

    // Shuffle the list to prevent predictable sequences
    recoveryCodeChars.shuffle(rand);

    return recoveryCodeChars.join();
  }
}
