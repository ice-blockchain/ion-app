// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ion/app/services/nostr/nostr_logger.dart';
import 'package:ion/app/services/nostr/nostr_signature_verifier.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Nostr {
  Nostr._();

  static void initialize(String? logFilePath) {
    NostrDart.configure(
      signatureVerifier: NostrSignatureVerifier(),
      logger: logFilePath != null
          ? NostrLogger(
              fileOutput: File(logFilePath),
            )
          : null,
    );
  }
}
