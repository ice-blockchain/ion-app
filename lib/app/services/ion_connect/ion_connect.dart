// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_connect/ion_connect_signature_verifier.dart';
import 'package:ion/app/services/logger/config.dart';
import 'package:ion/app/services/nostr/nostr_logger.dart';
import 'package:ion/app/services/nostr/nostr_signature_verifier.dart';
import 'package:nostr_dart/nostr_dart.dart';

class IonConnect {
  IonConnect._();

  static void initialize(NostrLogger? logger) {
    NostrDart.configure(
      signatureVerifier: NostrSignatureVerifier(),
      logger: logger,
    );
  }
}
