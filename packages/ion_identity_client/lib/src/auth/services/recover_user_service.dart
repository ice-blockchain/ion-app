// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/auth/result_types/recover_user_result.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/extensions/passkey_signer_extentions.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class RecoverUserService {
  RecoverUserService({
    required this.username,
    required this.dataSource,
    required this.config,
    required this.passkeySigner,
    required this.keyService,
  });

  final String username;
  final RecoverUserDataSource dataSource;
  final IonClientConfig config;
  final PasskeysSigner passkeySigner;
  final KeyService keyService;

  Future<RecoverUserResult> recoverUser({
    required String credentialId,
    required String recoveryKey,
  }) async {
    final result = await passkeySigner
        .registerChallenge(
          dataSource.createDelegatedRecoveryChallenge(
            username: username,
            credentialId: credentialId,
          ),
          SignChallengeRecoverUserFailure.new,
        )
        .flatMap(
          (signedChallenge) => TaskEither<RecoverUserFailure, JsonObject>.tryCatch(
            () => _signNewCredentials(
              encryptedKey: signedChallenge
                  .userRegistrationChallenge.allowedRecoveryCredentials![0].encryptedRecoveryKey,
              recoveryKey: recoveryKey,
              credentialId: credentialId,
              newCredentials: {
                'firstFactorCredential': signedChallenge.attestation.toJson(),
              },
            ),
            SignNewCredentialsRecoverUserFailure.new,
          ).flatMap<JsonObject>(
            (signedRecoveryPackage) => dataSource.recoverUser(
              recoveryData: {
                'newCredentials': {
                  'firstFactorCredential': signedChallenge.attestation.toJson(),
                },
                'recovery': signedRecoveryPackage,
              },
              temporaryAuthenticationToken:
                  signedChallenge.userRegistrationChallenge.temporaryAuthenticationToken,
            ),
          ),
        )
        .run();

    return result.fold(
      (l) => l,
      (r) => const RecoverUserSuccess(),
    );
  }

  Future<Map<String, dynamic>> _signNewCredentials({
    required String encryptedKey,
    required String recoveryKey,
    required String credentialId,
    required Map<String, dynamic> newCredentials,
  }) async {
    final recoveryClientData = jsonEncode({
      'challenge': base64UrlEncode(utf8.encode(jsonEncode(newCredentials))),
      'crossOrigin': false,
      'origin': config.origin,
      'type': 'key.get',
    });

    final signature = await generateSignature(
      encryptedPrivateKey: encryptedKey,
      recoveryKey: recoveryKey,
      message: recoveryClientData,
      encoding: 'base64Url',
    );

    return {
      'kind': 'RecoveryKey',
      'credentialAssertion': {
        'credId': credentialId,
        'clientData': base64UrlEncode(utf8.encode(recoveryClientData)),
        'signature': signature,
      },
    };
  }

  // Generate signature using the decrypted private key
  Future<String> generateSignature({
    required String encryptedPrivateKey,
    required String message,
    required String encoding,
    required String recoveryKey,
  }) async {
    final privateKeyPem = await keyService.decryptPrivateKey(encryptedPrivateKey, recoveryKey);

    final privateKey = await keyService.pemToPrivateKey(privateKeyPem);

    final algorithm = cryptography.Ed25519();

    final signature = await algorithm.sign(
      utf8.encode(message),
      keyPair: privateKey,
    );

    if (encoding == 'hex') {
      return signature.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    } else if (encoding == 'base64Url') {
      return base64UrlEncode(signature.bytes);
    } else {
      throw Exception('Unsupported encoding');
    }
  }
}
