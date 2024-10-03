// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/auth/result_types/recover_user_result.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
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
    final challengeResult = await dataSource
        .createDelegatedRecoveryChallenge(
          username: username,
          credentialId: credentialId,
        )
        .run();

    final challenge = challengeResult.toNullable()!;

    await _validateRecoveryKey(
      encryptedKey: challenge.allowedRecoveryCredentials![0].encryptedRecoveryKey,
      recoveryKey: recoveryKey,
    );

    final newPasskeyAttestation = await passkeySigner.register(challenge);

    final signedRecoveryPackage = await _signNewCredentials(
      encryptedKey: challenge.allowedRecoveryCredentials![0].encryptedRecoveryKey,
      recoveryKey: recoveryKey,
      credentialId: credentialId,
      newCredentials: {
        'firstFactorCredential': newPasskeyAttestation.toJson(),
      },
    );

    final result = await dataSource.recoverUser(
      recoveryData: {
        'newCredentials': {
          'firstFactorCredential': newPasskeyAttestation.toJson(),
        },
        'recovery': signedRecoveryPackage,
      },
      temporaryAuthenticationToken: challenge.temporaryAuthenticationToken,
    ).run();

    return result.fold(
      (l) => RecoverUserFailure(l, StackTrace.current),
      (r) => const RecoverUserSuccess(),
    );
  }

  Future<void> _validateRecoveryKey({
    required String encryptedKey,
    required String recoveryKey,
  }) async {
    final privateKeyPem = await keyService.decryptPrivateKey(encryptedKey, recoveryKey);

    final privateKey = await keyService.pemToPrivateKey(privateKeyPem);

    // Sign a random message to validate the key
    final randomMessage = cryptography.SecretKeyData.random(length: 64).bytes;

    final algorithm = cryptography.Ed25519();

    await algorithm.sign(
      randomMessage,
      keyPair: privateKey,
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
