// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/logger/config.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Nostr {
  Nostr._();

  // TODO:pass custom Signer that can handle `eddsa/curve25519` signatures
  static void initialize() {
    setNostrLogLevel(
      LoggerConfig.nostrLogsEnabled ? NostrLogLevel.ALL : NostrLogLevel.OFF,
    );
  }
}
