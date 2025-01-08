// SPDX-License-Identifier: ice License 1.0

import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Logger {
  Logger._();

  static final Talker talker = TalkerFlutter.init();

  static final talkerDioLogger = TalkerDioLogger(
    talker: talker,
    settings: TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: true,
      requestPen: AnsiPen()..cyan(),
      responsePen: AnsiPen()..green(),
      errorPen: AnsiPen()..red(),
    ),
  );

  static void log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    talker.log(message);

    if (error != null) {
      talker.error(error, stackTrace);
    }
  }

  static void info(String message) => talker.info(message);

  static void warning(String message) => talker.warning(message);

  static void error(
    Object error, {
    StackTrace? stackTrace,
  }) {
    talker.error(error, stackTrace);
  }
}
