// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/logger/config.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Nostr {
  Nostr._();

  static void initialize() {
    NostrDart.configure(
      // ignore: avoid_redundant_argument_values
      logLevel: LoggerConfig.nostrLogsEnabled ? NostrLogLevel.ALL : NostrLogLevel.OFF,
      signatureVerifier: SignatureVerifier(),
    );
  }
}

class SignatureVerifier extends SchnorrSignatureVerifier {
  SignatureVerifier();

  @override
  bool verify({
    required String signature,
    required String message,
    required String publicKey,
  }) {
    final signatureParts = signature.split(':');
    if (signatureParts.length == 2) {
      final [prefix, signatureBody] = signatureParts;
      if (prefix == 'eddsa/curve25519') {
        _verifyEddsaCurve25519Signature(
          signature: signatureBody,
          message: message,
          publicKey: publicKey,
        );
      }
      throw UnimplementedError('Signature verification for $prefix is not implemented');
    }
    return super.verify(signature: signature, message: message, publicKey: publicKey);
  }

  bool _verifyEddsaCurve25519Signature({
    required String signature,
    required String message,
    required String publicKey,
  }) {
    return false;
  }
}
