// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/logger/config.dart';
import 'package:ice/app/services/nostr/nostr_signature_verifier.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Nostr {
  Nostr._();

  static void initialize() {
    NostrDart.configure(
      // ignore: avoid_redundant_argument_values
      logLevel: LoggerConfig.nostrLogsEnabled ? NostrLogLevel.ALL : NostrLogLevel.OFF,
      signatureVerifier: NostrSignatureVerifier(),
    );
  }
}
