// SPDX-License-Identifier: ice License 1.0

import 'dart:developer' as developer;

class Logger {
  Logger._();

  static void log(
    String message, {
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(message, name: name, error: error, stackTrace: stackTrace);
  }
}
