import 'dart:io';

import 'package:logger/logger.dart' as log;
import 'package:nostr_dart/nostr_dart.dart';

class NostrLogger implements NostrDartLogger {
  NostrLogger({File? fileOutput})
      : _log = log.Logger(
          printer: log.PrettyPrinter(
            methodCount: 0,
            lineLength: 1000,
            dateTimeFormat: log.DateTimeFormat.dateAndTime,
          ),
          level: log.Level.all,
          output: log.MultiOutput([
            log.ConsoleOutput(),
            if (fileOutput != null) log.FileOutput(file: fileOutput),
          ]),
        );

  static String logFileName = 'nostr_logs.txt';

  final log.Logger _log;

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log.w(message, error: error, stackTrace: stackTrace);
  }
}
