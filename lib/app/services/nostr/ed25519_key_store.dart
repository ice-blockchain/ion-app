import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Ed25519KeyStore with EventSigner {
  Ed25519KeyStore._({
    required List<int> privateKeyBytes,
    required List<int> publicKeyBytes,
  })  : _publicKeyBytes = publicKeyBytes,
        _privateKeyBytes = privateKeyBytes;

  static Future<Ed25519KeyStore> generate() {
    final privateKeyBytes = Uint8List(KeyPairType.ed25519.privateKeyLength);
    return Ed25519KeyStore.fromPrivate(utf8.decode(privateKeyBytes));
  }

  static Future<Ed25519KeyStore> fromPrivate(String privateKey) async {
    final privateKeyBytes = utf8.encode(privateKey);
    final keyPair = await Ed25519().newKeyPairFromSeed(privateKeyBytes);
    final publicKey = await keyPair.extractPublicKey();

    return Ed25519KeyStore._(
      privateKeyBytes: privateKeyBytes,
      publicKeyBytes: publicKey.bytes,
    );
  }

  @override
  String get publicKey => utf8.decode(_publicKeyBytes);

  String get privateKey => utf8.decode(_privateKeyBytes);

  final List<int> _publicKeyBytes;

  final List<int> _privateKeyBytes;

  @override
  Future<String> sign({required String message}) async {
    final algorithm = Ed25519();
    final keyPair = SimpleKeyPairData(
      _privateKeyBytes,
      publicKey: SimplePublicKey(_privateKeyBytes, type: KeyPairType.ed25519),
      type: KeyPairType.ed25519,
    );
    final signature = await algorithm.signString(message, keyPair: keyPair);
    return '$signaturePrefix${utf8.decode(signature.bytes)}';
  }

  static Future<bool> verifyEddsaCurve25519Signature({
    required String signature,
    required String message,
    required String publicKey,
  }) async {
    //TODO:try without Uint8List.fromList
    final publicKeyBytes = Uint8List.fromList(hex.decode(publicKey));
    final signatureBytes = Uint8List.fromList(hex.decode(signature));
    final messageBytes = Uint8List.fromList(hex.decode(message));

    final signatureObject = Signature(
      signatureBytes,
      publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
    );

    return Ed25519().verify(messageBytes, signature: signatureObject);
  }

  static const signaturePrefix = 'eddsa/curve25519';
}
