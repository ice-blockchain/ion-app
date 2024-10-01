// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/result_types/recover_user_result.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class RecoverUserService {
  RecoverUserService({
    required this.username,
    required this.dataSource,
    required this.config,
    required this.passkeySigner,
  });

  final String username;
  final RecoverUserDataSource dataSource;
  final IonClientConfig config;
  final PasskeysSigner passkeySigner;

  Future<RecoverUserResult> recoverUser({
    required String credentialId,
    required String recoveryKey, // Currently unused
  }) async {
    // Step 1: Get the recovery challenge
    final challengeResult = await dataSource
        .createDelegatedRecoveryChallenge(
          username: username,
          credentialId: credentialId,
        )
        .run();

    final challenge = challengeResult.toNullable()!;

    // Step 2: Validate the recovery key
    await _validateRecoveryKey(
      encryptedKey: challenge.allowedRecoveryCredentials![0].encryptedRecoveryKey,
    );

    // Step 3: Create new recovery credential
    final newRecoveryCredential = await _createNewRecoveryCredential(
      clientDataChallenge: challenge.challenge,
      origin: config.origin,
    );

    // Step 4: Create new Passkey credentials
    final newPasskeyAttestation = await passkeySigner.register(challenge);

    // Step 5: Sign new credentials with existing recovery key
    final signedRecoveryPackage = await _signNewCredentials(
      encryptedKey: challenge.allowedRecoveryCredentials![0].encryptedRecoveryKey,
      credentialId: credentialId,
      newCredentials: {
        'firstFactorCredential': newPasskeyAttestation.toJson(),
        'recoveryCredential': newRecoveryCredential.toJson(),
      },
    );

    // Step 6: Send recovery data to the API
    final result = await dataSource.recoverUser(
      recoveryData: {
        'newCredentials': {
          'firstFactorCredential': newPasskeyAttestation.toJson(),
          'recoveryCredential': newRecoveryCredential.toJson(),
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

  // Step 2: Validate the recovery key
  Future<void> _validateRecoveryKey({
    required String encryptedKey,
  }) async {
    final privateKeyPem = decryptPrivateKey(encryptedKey);

    final privateKey = await pemToPrivateKey(privateKeyPem);

    // Sign a random message to validate the key
    final randomMessage = cryptography.SecretKeyData.random(length: 64).bytes;

    final algorithm = cryptography.Ed25519();

    await algorithm.sign(
      randomMessage,
      keyPair: privateKey,
    );
  }

  // Step 3: Create a new recovery credential
  Future<CredentialRequestData> _createNewRecoveryCredential({
    required String clientDataChallenge,
    required String origin,
  }) async {
    // Generate a new Ed25519 key pair
    final keyPair = await generateKeyPair();

    // Encrypt private key (currently just base64Url encode)
    final encryptedPrivateKey = encryptPrivateKey(keyPair.privateKeyPem);

    // Build clientData
    final clientData = buildClientData(
      challenge: clientDataChallenge,
      origin: origin,
    );

    final clientDataHash = sha256Hash(utf8.encode(clientData));

    // Build credentialInfoFingerprint
    final credentialInfoFingerprint = buildCredentialInfoFingerprint(
      clientDataHash: clientDataHash,
      publicKeyPem: keyPair.publicKeyPem,
    );

    // Sign credentialInfoFingerprint
    final signature = await signCredentialInfoFingerprint(
      credentialInfoFingerprint,
      keyPair.keyPair,
    );

    // Build attestationData
    final attestationData = buildAttestationData(
      publicKeyPem: keyPair.publicKeyPem,
      signatureHex: signature,
    );

    final clientDataBase64Url = base64UrlEncode(utf8.encode(clientData));
    final attestationDataBase64Url = base64UrlEncode(utf8.encode(attestationData));

    final credId = generateCredId(keyPair.publicKey);

    final credentialInfo = CredentialInfo(
      credId: credId,
      clientData: clientDataBase64Url,
      attestationData: attestationDataBase64Url,
    );

    final recoveryCredential = CredentialRequestData(
      credentialKind: 'RecoveryKey',
      credentialInfo: credentialInfo,
      encryptedPrivateKey: encryptedPrivateKey,
    );

    return recoveryCredential;
  }

  // Step 5: Sign new credentials with existing recovery key
  Future<Map<String, dynamic>> _signNewCredentials({
    required String encryptedKey,
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

  // Helper functions (cryptographic operations)

  // Since the private key is base64Url-encoded, decryption is simply decoding
  String decryptPrivateKey(String encryptedPrivateKey) {
    final privateKeyPem = utf8.decode(base64Url.decode(encryptedPrivateKey));
    return privateKeyPem;
  }

  // Generate signature using the decrypted private key
  Future<String> generateSignature({
    required String encryptedPrivateKey,
    required String message,
    required String encoding,
  }) async {
    final privateKeyPem = decryptPrivateKey(encryptedPrivateKey);

    final privateKey = await pemToPrivateKey(privateKeyPem);

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

  // Generate a new Ed25519 key pair
  Future<KeyPairData> generateKeyPair() async {
    final algorithm = cryptography.Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final keyPairData = await keyPair.extract();
    final publicKey = keyPairData.publicKey;
    final privateKeyBytes = await keyPairData.extractPrivateKeyBytes();

    // Convert keys to PEM format
    final publicKeyPem = encodeEd25519PublicKeyToPem(Uint8List.fromList(publicKey.bytes));
    final privateKeyPem = encodeEd25519PrivateKeyToPem(Uint8List.fromList(privateKeyBytes));

    return KeyPairData(
      keyPair: keyPairData,
      publicKey: publicKey,
      publicKeyPem: publicKeyPem,
      privateKeyPem: privateKeyPem,
      privateKeyBytes: privateKeyBytes,
    );
  }

  // Helper functions to encode keys to PEM format (same as in CreateRecoveryCredentialsService)
  String encodeEd25519PublicKeyToPem(Uint8List publicKeyBytes) {
    // OID for Ed25519
    final algorithmSeq = ASN1Sequence()
      ..add(ASN1ObjectIdentifier.fromComponentString('1.3.101.112'));

    final publicKeyBitString = ASN1BitString(publicKeyBytes);

    final subjectPublicKeyInfo = ASN1Sequence()
      ..add(algorithmSeq)
      ..add(publicKeyBitString);

    final bytes = subjectPublicKeyInfo.encodedBytes;
    final base64Str = base64.encode(bytes);

    return '-----BEGIN PUBLIC KEY-----\n${chunk(base64Str)}-----END PUBLIC KEY-----';
  }

  String encodeEd25519PrivateKeyToPem(Uint8List privateKeyBytes) {
    // OID for Ed25519
    final algorithmSeq = ASN1Sequence()
      ..add(ASN1ObjectIdentifier.fromComponentString('1.3.101.112'));

    final privateKeyOctetString = ASN1OctetString(privateKeyBytes);

    // Wrap the private key in another OCTET STRING
    final innerOctetString = ASN1OctetString(privateKeyOctetString.encodedBytes);

    final privateKeyInfoSeq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.zero)) // Version
      ..add(algorithmSeq)
      ..add(innerOctetString);

    final bytes = privateKeyInfoSeq.encodedBytes;
    final base64Str = base64.encode(bytes);

    return '-----BEGIN PRIVATE KEY-----\n${chunk(base64Str)}\n-----END PRIVATE KEY-----';
  }

  String chunk(String str, [int size = 64]) {
    final sb = StringBuffer();
    for (var i = 0; i < str.length; i += size) {
      sb.writeln(str.substring(i, i + size > str.length ? str.length : i + size));
    }
    return sb.toString();
  }

  // Build client data (same as in CreateRecoveryCredentialsService)
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

    final sortedClientDataMap = Map.fromEntries(
      clientDataMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    return jsonEncode(sortedClientDataMap);
  }

  // Computes SHA256 hash (same as in CreateRecoveryCredentialsService)
  String sha256Hash(List<int> data) {
    final hash = crypto.sha256.convert(data);
    return hash.toString();
  }

  // Builds the credential info fingerprint JSON string (same as in CreateRecoveryCredentialsService)
  String buildCredentialInfoFingerprint({
    required String clientDataHash,
    required String publicKeyPem,
  }) {
    final fingerprintMap = {
      'clientDataHash': clientDataHash,
      'publicKey': publicKeyPem,
    };

    final sortedFingerprintMap = Map.fromEntries(
      fingerprintMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    return jsonEncode(sortedFingerprintMap);
  }

  // Signs the credential info fingerprint (same as in CreateRecoveryCredentialsService)
  Future<String> signCredentialInfoFingerprint(
    String fingerprintData,
    cryptography.SimpleKeyPairData privateKey,
  ) async {
    final algorithm = cryptography.Ed25519();

    // Sign the data
    final signature = await algorithm.sign(
      utf8.encode(fingerprintData),
      keyPair: privateKey,
    );

    return signature.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  // Builds the attestation data JSON string (same as in CreateRecoveryCredentialsService)
  String buildAttestationData({
    required String publicKeyPem,
    required String signatureHex,
  }) {
    final attestationDataMap = {
      'publicKey': publicKeyPem,
      'signature': signatureHex,
    };

    final sortedAttestationDataMap = Map.fromEntries(
      attestationDataMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    return jsonEncode(sortedAttestationDataMap);
  }

  // Generates a credential ID (credId) (same as in CreateRecoveryCredentialsService)
  String generateCredId(cryptography.SimplePublicKey publicKey) {
    final hash = crypto.sha256.convert(publicKey.bytes);
    return base64UrlEncode(hash.bytes);
  }

  // Since encryption is just base64Url encoding, we can replicate that
  String encryptPrivateKey(String privateKeyPem) {
    return base64UrlEncode(utf8.encode(privateKeyPem));
  }

  // Convert PEM formatted private key to SimpleKeyPairData
  Future<cryptography.SimpleKeyPairData> pemToPrivateKey(String privateKeyPem) async {
    // Remove PEM headers and footers
    final pemLines = privateKeyPem.split('\n').where((line) => !line.startsWith('-----')).toList();
    final base64Str = pemLines.join();
    final derBytes = base64.decode(base64Str);

    // Parse the ASN.1 structure
    final asn1Parser = ASN1Parser(derBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // Extract the privateKey field (OCTET STRING)
    final privateKeyOctetString = topLevelSeq.elements[2] as ASN1OctetString;

    // The privateKeyOctetString contains another OCTET STRING which contains the seed
    final innerParser = ASN1Parser(privateKeyOctetString.valueBytes());
    final innerOctetString = innerParser.nextObject() as ASN1OctetString;
    final privateKeyBytes = innerOctetString.valueBytes();

    // Now privateKeyBytes should be the 32-byte seed
    if (privateKeyBytes.length != 32) {
      throw ArgumentError(
        'Invalid private key length: expected 32 bytes, got ${privateKeyBytes.length}',
      );
    }

    final algorithm = cryptography.Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(privateKeyBytes);

    return keyPair.extract();
  }
}
