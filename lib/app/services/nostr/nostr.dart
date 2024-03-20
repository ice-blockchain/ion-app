import 'package:ice/app/services/logger/config.dart';
import 'package:nostr_dart/nostr_dart.dart';

class Nostr {
  Nostr._();

  static void initialize() {
    setNostrLogLevel(
      LoggerConfig.nostrLogsEnabled ? NostrLogLevel.ALL : NostrLogLevel.OFF,
    );
  }
}
