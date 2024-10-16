import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
import 'package:nostr_dart/nostr_dart.dart';

class NostrSignatureVerifier extends SchnorrSignatureVerifier {
  NostrSignatureVerifier();

  @override
  Future<bool> verify({
    required String signature,
    required String message,
    required String publicKey,
  }) {
    final signatureParts = signature.split(':');
    if (signatureParts.length == 2) {
      final [prefix, signatureBody] = signatureParts;
      if (prefix == 'eddsa/ed25519') {
        return _verifyEddsaCurve25519Signature(
          signature: signatureBody,
          message: message,
          publicKey: publicKey,
        );
      }
      throw UnimplementedError('Signature verification for $prefix is not implemented');
    }
    return super.verify(signature: signature, message: message, publicKey: publicKey);
  }

  Future<bool> _verifyEddsaCurve25519Signature({
    required String signature,
    required String message,
    required String publicKey,
  }) async {
    final publicKeyBytes = Uint8List.fromList(hex.decode(publicKey));
    final signatureBytes = Uint8List.fromList(hex.decode(signature));

    final signatureObject = Signature(
      signatureBytes,
      publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
    );

    final algorithm = DartEd25519();

    return algorithm.verifyString(
      message,
      signature: signatureObject,
    );
  }
}
