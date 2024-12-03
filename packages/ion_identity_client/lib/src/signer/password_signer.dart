// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';

class PasswordSigner {
  PasswordSigner({
    required this.config,
    required this.keyService,
  });

  final KeyService keyService;
  final IONIdentityConfig config;

  Future<CredentialRequestData> getCredentialInfo({
    required String challenge,
    required String password,
    required CredentialKind credentialKind,
  }) async {
    final keyPair = await keyService.generateKeyPair();

    final clientData = buildClientData(
      challenge: challenge,
      origin: config.origin,
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

    final encryptedPrivateKey = await keyService.encryptPrivateKey(
      keyPair.privateKeyPem,
      password,
    );

    return CredentialRequestData(
      credentialInfo: CredentialInfo(
        credId: credId,
        clientData: clientDataBase64Url,
        attestationData: attestationDataBase64Url,
      ),
      credentialKind: credentialKind,
      encryptedPrivateKey: encryptedPrivateKey,
    );
  }

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
}
