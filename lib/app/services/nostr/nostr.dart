// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/nostr/nostr_logger.dart';
import 'package:ion/app/services/nostr/nostr_signature_verifier.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Nostr {
  Nostr._();

  static void initialize(NostrLogger? logger) {
    NostrDart.configure(
      signatureVerifier: NostrSignatureVerifier(),
      logger: logger,
    );
  }
}
