import 'package:cryptography/cryptography.dart';

class KeyPairData {
  KeyPairData({
    required this.keyPair,
    required this.publicKey,
    required this.publicKeyPem,
    required this.privateKeyPem,
    required this.privateKeyBytes,
  });

  final SimpleKeyPairData keyPair;
  final SimplePublicKey publicKey;
  final String publicKeyPem;
  final String privateKeyPem;
  final List<int> privateKeyBytes;
}
