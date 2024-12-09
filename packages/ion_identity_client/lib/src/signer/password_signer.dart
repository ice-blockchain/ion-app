// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/dtos/client_data_type.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

enum SignatureEncryption { hex, base64Url }

class PasswordSigner {
  PasswordSigner({
    required this.config,
    required this.keyService,
    required this.privateKeyStorage,
  });

  final KeyService keyService;
  final IONIdentityConfig config;
  final PrivateKeyStorage privateKeyStorage;

  Future<CredentialRequestData> createCredentialInfo({
    required String challenge,
    required String password,
    required String username,
    required CredentialKind credentialKind,
  }) async {
    final keyPair = await keyService.generateKeyPair();

    final clientData = buildClientData(
      challenge: challenge,
      origin: config.origin,
      clientDataType: ClientDataType.createKey,
    );

    final clientDataHash = sha256Hash(utf8.encode(clientData));

    final credentialInfoFingerprint = buildCredentialInfoFingerprint(
      clientDataHash: clientDataHash,
      publicKeyPem: keyPair.publicKeyPem,
    );

    final signature = await signDataWithPrivateKey(
      data: credentialInfoFingerprint,
      privateKey: keyPair.keyPair,
      signatureEncryption: SignatureEncryption.hex,
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

    await privateKeyStorage.setPrivateKey(username: username, privateKey: keyPair.privateKeyPem);

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

  Future<AssertionRequestData> createCredentialAssertion({
    required String challenge,
    required String encryptedPrivateKey,
    required String password,
    required String credentialId,
    required CredentialKind credentialKind,
  }) async {
    final keyPair =
        await keyService.reconstructKeyPairFromEncryptedPrivateKey(encryptedPrivateKey, password);
    final clientData = buildClientData(
      challenge: challenge,
      origin: config.origin,
      clientDataType: ClientDataType.getKey,
    );

    final signature = await signDataWithPrivateKey(
      data: clientData,
      privateKey: keyPair.keyPair,
      signatureEncryption: SignatureEncryption.base64Url,
    );

    return AssertionRequestData(
      kind: credentialKind,
      credentialAssertion: CredentialAssertionData(
        clientData: base64UrlEncode(utf8.encode(clientData)),
        credId: credentialId,
        signature: signature,
      ),
    );
  }

  String buildClientData({
    required String challenge,
    required String origin,
    required ClientDataType clientDataType,
  }) {
    final clientDataMap = {
      'challenge': challenge,
      'crossOrigin': false,
      'origin': origin,
      'type': clientDataType.value,
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

  Future<String> signDataWithPrivateKey({
    required String data,
    required crypto.SimpleKeyPairData privateKey,
    required SignatureEncryption signatureEncryption,
  }) async {
    final algorithm = crypto.Ed25519();

    final signature = await algorithm.sign(
      utf8.encode(data),
      keyPair: privateKey,
    );

    return switch (signatureEncryption) {
      SignatureEncryption.hex =>
        signature.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      SignatureEncryption.base64Url => base64UrlEncode(signature.bytes),
    };
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
