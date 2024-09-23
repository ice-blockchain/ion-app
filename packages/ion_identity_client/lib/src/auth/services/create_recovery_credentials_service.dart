import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/data_sources/create_recovery_credentials_data_source.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_info.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_request_data.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_response.dart';
import 'package:ion_identity_client/src/auth/dtos/key_pair_data.dart';
import 'package:ion_identity_client/src/auth/dtos/recovery_key_data.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';

class CreateRecoveryCredentialsService {
  CreateRecoveryCredentialsService({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.userActionSigner,
  });

  final String username;
  final IonClientConfig config;
  final CreateRecoveryCredentialsDataSource dataSource;
  final UserActionSigner userActionSigner;

  Future<CreateRecoveryCredentialsResult> createRecoveryCredentials() async {
    final challengeResponse = await dataSource.createCredentialInit(username: username).run();
    final credentialChallenge = challengeResponse.toNullable()!;

    final recoveryKeyData = await createRecoveryKey(
      challenge: credentialChallenge.challenge,
      origin: config.origin,
    );

    final credentialRequestData = CredentialRequestData(
      challengeIdentifier: credentialChallenge.challengeIdentifier,
      credentialName: recoveryKeyData.name,
      credentialKind: 'RecoveryKey',
      credentialInfo: recoveryKeyData.credentialInfo,
      encryptedPrivateKey: recoveryKeyData.encryptedPrivateKey,
    );

    final request = dataSource.buildCreateCredentialSigningRequest(username, credentialRequestData);
    final result = await userActionSigner.execute(request, CredentialResponse.fromJson).run();

    return result.fold(
      (failure) => CreateRecoveryCredentialsFailure(failure, StackTrace.current),
      (success) => CreateRecoveryCredentialsSuccess(
        recoveryCode: recoveryKeyData.recoveryCode,
        recoveryName: success.name,
        recoveryId: success.credentialId,
      ),
    );
  }

  Future<RecoveryKeyData> createRecoveryKey({
    required String challenge,
    required String origin,
  }) async {
    final keyPair = await generateKeyPair();

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

    final encryptedPrivateKey = encryptPrivateKey(keyPair.privateKeyPem);

    final credentialInfo = CredentialInfo(
      credId: credId,
      clientData: clientDataBase64Url,
      attestationData: attestationDataBase64Url,
    );

    // TODO: Implement recovery code generation
    const recoveryCode = 'generateRecoveryCode(keyPair.privateKeyBytes)';

    return RecoveryKeyData(
      credentialInfo: credentialInfo,
      encryptedPrivateKey: encryptedPrivateKey,
      recoveryCode: recoveryCode,
      name: generateCredentialName(),
    );
  }

  // Generates an Ed25519 key pair
  Future<KeyPairData> generateKeyPair() async {
    final algorithm = crypto.Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final keyPairData = await keyPair.extract();
    final publicKey = keyPairData.publicKey;
    final privateKeyBytes = await keyPairData.extractPrivateKeyBytes();

    // Convert keys to PEM format if necessary
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

  // Signs the credential info fingerprint
  Future<String> signCredentialInfoFingerprint(
    String fingerprintData,
    crypto.SimpleKeyPairData privateKey,
  ) async {
    final algorithm = crypto.Ed25519();

    // Sign the data
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

  // Generates a credential ID (credId)
  String generateCredId(crypto.SimplePublicKey publicKey) {
    // For simplicity, use the SHA256 hash of the public key bytes
    final hash = sha256.convert(publicKey.bytes);
    return base64UrlEncode(hash.bytes);
  }

  // Placeholder function to encrypt the private key
  String encryptPrivateKey(String privateKeyPem) {
    // TODO: Implement private key encryption
    return base64UrlEncode(utf8.encode(privateKeyPem));
  }

  // Helper functions to encode keys to PEM format
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

  String chunk(String str, [int size = 64]) {
    final sb = StringBuffer();
    for (var i = 0; i < str.length; i += size) {
      sb.writeln(str.substring(i, i + size > str.length ? str.length : i + size));
    }
    return sb.toString();
  }

  String encodeEd25519PrivateKeyToPem(Uint8List privateKeyBytes) {
    // OID for Ed25519
    final algorithmSeq = ASN1Sequence()
      ..add(ASN1ObjectIdentifier.fromComponentString('1.3.101.112'));

    final privateKeyOctetString = ASN1OctetString(privateKeyBytes);

    final privateKeyInfoSeq = ASN1Sequence()
      ..add(ASN1Integer(BigInt.zero)) // Version
      ..add(algorithmSeq)
      ..add(ASN1OctetString(privateKeyOctetString.encodedBytes));

    final bytes = privateKeyInfoSeq.encodedBytes;
    final base64Str = base64.encode(bytes);

    return '-----BEGIN PRIVATE KEY-----\n${chunk(base64Str)}\n-----END PRIVATE KEY-----';
  }

  String generateCredentialName() => 'main';
}
