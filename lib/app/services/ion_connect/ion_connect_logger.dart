// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/logger/logger.dart';
import 'package:nostr_dart/nostr_dart.dart';

class IonConnectLogger implements NostrDartLogger {
  static const _prefix = '🦩 IonConnect:';

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.info('$_prefix $message');

    if (error != null) {
      Logger.error('$_prefix $error', stackTrace: stackTrace);
    }
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.warning('$_prefix $message');

    if (error != null) {
      Logger.error('$_prefix $error', stackTrace: stackTrace);
    }
  }
}
