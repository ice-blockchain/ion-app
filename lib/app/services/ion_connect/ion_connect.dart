// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ion_connect_logger.dart';
import 'package:ion/app/services/ion_connect/ion_connect_signature_verifier.dart';

class IonConnect {
  IonConnect._();

  static void initialize(IonConnectLogger? logger) {
    NostrDart.configure(
      signatureVerifier: IonConnectSignatureVerifier(),
      logger: logger,
    );
  }
}
