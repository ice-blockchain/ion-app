// SPDX-License-Identifier: ice License 1.0

import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:ion/app/exceptions/exceptions.dart';
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
      return switch (prefix) {
        'eddsa/curve25519' => _verifyEddsaCurve25519Signature(
            signature: signatureBody,
            message: message,
            publicKey: publicKey,
          ),
        //TODO: impl a general fallback here
        _ => throw UnsupportedSignatureAlgorithmException(prefix)
      };
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
    final messageBytes = Uint8List.fromList(hex.decode(message));

    final signatureObject = Signature(
      signatureBytes,
      publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
    );

    return Ed25519().verify(messageBytes, signature: signatureObject);
  }
}
