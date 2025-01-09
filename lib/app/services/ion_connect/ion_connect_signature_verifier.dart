// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:nostr_dart/nostr_dart.dart';

class IonConnectSignatureVerifier extends SchnorrSignatureVerifier {
  IonConnectSignatureVerifier();

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
        Ed25519KeyStore.signaturePrefix => Ed25519KeyStore.verifyEddsaCurve25519Signature(
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
}
