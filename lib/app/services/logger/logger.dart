// SPDX-License-Identifier: ice License 1.0

import 'dart:developer' as developer;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Logger {
  Logger._();

  static String logFileName = 'app_logs.txt';
  static File? _logFile;

  static void log(
    String message, {
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(message, name: name, error: error, stackTrace: stackTrace);
    _writeToLogs(message, name: name, error: error, stackTrace: stackTrace);
  }

  static Future<void> _initLogFile() async {
    if (_logFile != null) return;
    final dir = await getTemporaryDirectory();
    _logFile = File('${dir.path}/$logFileName');
  }

  static Future<void> _writeToLogs(
    String message, {
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) async {
    await _initLogFile();

    final timestamp = DateTime.now().toIso8601String();
    final separator = '=' * 50;

    final logEntry = '$separator\n'
        '📝 Log Entry at $timestamp\n'
        '${name.isNotEmpty ? '📌 Context: $name\n' : ''}'
        '💬 Message: $message\n'
        '${error != null ? '❌ Error: $error\n' : ''}'
        '${stackTrace != null ? '🔍 Stack Trace:\n$stackTrace\n' : ''}'
        '$separator\n\n';

    try {
      await _logFile?.writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      developer.log('Failed to write to log file: $e');
    }
  }
}
