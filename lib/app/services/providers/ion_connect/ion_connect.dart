// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/providers/ion_connect/ion_connect_logger.dart';
import 'package:ion/app/services/providers/ion_connect/ion_connect_signature_verifier.dart';
import 'package:nostr_dart/nostr_dart.dart';

class IonConnect {
  IonConnect._();

  static void initialize(IonConnectLogger? logger) {
    NostrDart.configure(
      signatureVerifier: IonConnectSignatureVerifier(),
      logger: logger,
    );
  }
}
