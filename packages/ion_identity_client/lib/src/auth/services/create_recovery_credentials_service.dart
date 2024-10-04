import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/data_sources/create_recovery_credentials_data_source.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_info.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_request_data.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_response.dart';
import 'package:ion_identity_client/src/auth/dtos/recovery_key_data.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:uuid/uuid.dart';

class CreateRecoveryCredentialsService {
  CreateRecoveryCredentialsService({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.userActionSigner,
    required this.keyService,
  });

  final String username;
  final IonClientConfig config;
  final CreateRecoveryCredentialsDataSource dataSource;
  final UserActionSigner userActionSigner;
  final KeyService keyService;

  Future<CreateRecoveryCredentialsResult> createRecoveryCredentials() async {
    final result = await dataSource
        .createCredentialInit(username: username)
        .flatMap(
          (credentialChallenge) =>
              TaskEither<CreateRecoveryCredentialsFailure, RecoveryKeyData>.tryCatch(
            () => createRecoveryKey(
              challenge: credentialChallenge.challenge,
              origin: config.origin,
            ),
            CreateRecoveryKeyCreateRecoveryCredentialsFailure.new,
          ).flatMap(
            (recoveryKeyData) {
              final credentialRequestData = CredentialRequestData(
                challengeIdentifier: credentialChallenge.challengeIdentifier,
                credentialName: recoveryKeyData.name,
                credentialKind: 'RecoveryKey',
                credentialInfo: recoveryKeyData.credentialInfo,
                encryptedPrivateKey: recoveryKeyData.encryptedPrivateKey,
              );

              final request = dataSource.buildCreateCredentialSigningRequest(
                username,
                credentialRequestData,
              );

              return userActionSigner
                  .execute(request, CredentialResponse.fromJson)
                  .mapLeft(CreateCredentialRequestCreateRecoveryCredentialsFailure.new)
                  .map(
                    (credentialResponse) => CreateRecoveryCredentialsSuccess(
                      recoveryCode: recoveryKeyData.recoveryCode,
                      recoveryName: credentialResponse.name,
                      recoveryId: credentialResponse.credentialId,
                    ),
                  );
            },
          ),
        )
        .run();

    return result.fold(
      (failure) => failure,
      (success) => success,
    );
  }

  Future<RecoveryKeyData> createRecoveryKey({
    required String challenge,
    required String origin,
  }) async {
    final keyPair = await keyService.generateKeyPair();

    final clientData = buildClientData(
      challenge: challenge,
      origin: origin,
    );

    final clientDataHash = sha256Hash(utf8.encode(clientData));

    final credentialInfoFingerprint = buildCredentialInfoFingerprint(
      clientDataHash: clientDataHash,
      publicKeyPem: keyPair.publicKeyPem,
    );

    final signature = await signCredentialInfoFingerprint(
      credentialInfoFingerprint,
      keyPair.keyPair,
    );

    final attestationData = buildAttestationData(
      publicKeyPem: keyPair.publicKeyPem,
      signatureHex: signature,
    );

    final clientDataBase64Url = base64UrlEncode(utf8.encode(clientData));
    final attestationDataBase64Url = base64UrlEncode(utf8.encode(attestationData));

    final credId = generateCredId(keyPair.publicKey);

    final recoveryCode = generateRecoveryCode();
    final encryptedPrivateKey = await keyService.encryptPrivateKey(
      keyPair.privateKeyPem,
      recoveryCode,
    );

    final credentialInfo = CredentialInfo(
      credId: credId,
      clientData: clientDataBase64Url,
      attestationData: attestationDataBase64Url,
    );

    return RecoveryKeyData(
      credentialInfo: credentialInfo,
      encryptedPrivateKey: encryptedPrivateKey,
      recoveryCode: recoveryCode,
      name: generateCredentialName(),
    );
  }

  // Builds the client data JSON string
  String buildClientData({
    required String challenge,
    required String origin,
  }) {
    final clientDataMap = {
      'challenge': challenge,
      'crossOrigin': false,
      'origin': origin,
      'type': 'key.create',
    };

    // Ensure keys are sorted alphabetically
    final sortedClientDataMap = Map.fromEntries(
      clientDataMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    return jsonEncode(sortedClientDataMap);
  }

  // Computes SHA256 hash
  String sha256Hash(List<int> data) {
    final hash = sha256.convert(data);
    return hash.toString();
  }

  // Builds the credential info fingerprint JSON string
  String buildCredentialInfoFingerprint({
    required String clientDataHash,
    required String publicKeyPem,
  }) {
    final fingerprintMap = {
      'clientDataHash': clientDataHash,
      'publicKey': publicKeyPem,
    };

    // Ensure keys are sorted alphabetically
    final sortedFingerprintMap = Map.fromEntries(
      fingerprintMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    return jsonEncode(sortedFingerprintMap);
  }

  Future<String> signCredentialInfoFingerprint(
    String fingerprintData,
    crypto.SimpleKeyPairData privateKey,
  ) async {
    final algorithm = crypto.Ed25519();

    final signature = await algorithm.sign(
      utf8.encode(fingerprintData),
      keyPair: privateKey,
    );

    return signature.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  // Builds the attestation data JSON string
  String buildAttestationData({
    required String publicKeyPem,
    required String signatureHex,
  }) {
    final attestationDataMap = {
      'publicKey': publicKeyPem,
      'signature': signatureHex,
    };

    // Ensure keys are sorted alphabetically
    final sortedAttestationDataMap = Map.fromEntries(
      attestationDataMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    return jsonEncode(sortedAttestationDataMap);
  }

  String generateCredentialName() => const Uuid().v4().toUpperCase();

  String generateCredId(crypto.SimplePublicKey publicKey) {
    final digest = sha256.convert(publicKey.bytes).bytes.sublist(0, 16);

    final base36Str = BigInt.parse(hex.encode(digest), radix: 16)
        .toRadixString(36)
        .toUpperCase()
        .padLeft(25, '0');

    final formattedStr =
        base36Str.replaceAllMapped(RegExp('.{5}'), (match) => '${match.group(0)}-');

    return formattedStr.endsWith('-')
        ? formattedStr.substring(0, formattedStr.length - 1)
        : formattedStr;
  }

  String generateRecoveryCode() {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    final codeUnits = List<int>.generate(30, (index) {
      final randomByte = random.nextInt(alphabet.length);
      return alphabet.codeUnitAt(randomByte);
    });

    final code = String.fromCharCodes(codeUnits);

    // Format the code with dashes
    return 'D1-'
        '${code.substring(0, 6)}-'
        '${code.substring(6, 11)}-'
        '${code.substring(11, 16)}-'
        '${code.substring(16, 21)}-'
        '${code.substring(21, 26)}-'
        '${code.substring(26)}';
  }
}
