// SPDX-License-Identifier: ice License 1.0

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Ed25519KeyStore with EventSigner {
  Ed25519KeyStore._({
    required List<int> privateKeyBytes,
    required List<int> publicKeyBytes,
  })  : _publicKeyBytes = publicKeyBytes,
        _privateKeyBytes = privateKeyBytes;

  static Future<Ed25519KeyStore> generate() async {
    final keyPair = await Ed25519().newKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();
    return Ed25519KeyStore._(
      privateKeyBytes: privateKeyBytes,
      publicKeyBytes: publicKey.bytes,
    );
  }

  static Future<Ed25519KeyStore> fromPrivate(String privateKey) async {
    final privateKeyBytes = hex.decode(privateKey);
    final keyPair = await Ed25519().newKeyPairFromSeed(privateKeyBytes);
    final publicKey = await keyPair.extractPublicKey();

    return Ed25519KeyStore._(
      privateKeyBytes: privateKeyBytes,
      publicKeyBytes: publicKey.bytes,
    );
  }

  @override
  String get publicKey => hex.encode(_publicKeyBytes);

  String get privateKey => hex.encode(_privateKeyBytes);

  final List<int> _publicKeyBytes;

  final List<int> _privateKeyBytes;

  @override
  Future<String> sign({required String message, bool addPrefix = true}) async {
    final algorithm = Ed25519();
    final keyPair = SimpleKeyPairData(
      _privateKeyBytes,
      publicKey: SimplePublicKey(_privateKeyBytes, type: KeyPairType.ed25519),
      type: KeyPairType.ed25519,
    );
    final messageBytes = hex.decode(message);
    final signature = await algorithm.sign(messageBytes, keyPair: keyPair);
    return '${addPrefix ? ('$signaturePrefix:') : ''}${hex.encode(signature.bytes)}';
  }

  static Future<bool> verifyEddsaCurve25519Signature({
    required String signature,
    required String message,
    required String publicKey,
  }) async {
    final publicKeyBytes = hex.decode(publicKey);
    final signatureBytes = hex.decode(signature);
    final messageBytes = hex.decode(message);

    final signatureObject = Signature(
      signatureBytes,
      publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
    );

    return Ed25519().verify(messageBytes, signature: signatureObject);
  }

  static const signaturePrefix = 'eddsa/curve25519';
}