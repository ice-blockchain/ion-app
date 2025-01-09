// SPDX-License-Identifier: ice License 1.0

import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Logger {
  factory Logger() {
    return _instance;
  }

  Logger._();

  static final Logger _instance = Logger._();

  Talker? _talker;

  Talker? get talker => _talker;

  void init() {
    _talker = TalkerFlutter.init();
  }

  TalkerDioLogger? get talkerDioLogger => TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          requestPen: AnsiPen()..cyan(),
          responsePen: AnsiPen()..green(),
          errorPen: AnsiPen()..red(),
        ),
      );

  void log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _talker?.log(message);

    if (error != null) {
      _talker?.error(error, stackTrace);
    }
  }

  void info(String message) {
    _talker?.info(message);
  }

  void warning(String message) {
    _talker?.warning(message);
  }

  void error(
    Object error, {
    StackTrace? stackTrace,
  }) {
    _talker?.error(error, stackTrace);
  }
}
