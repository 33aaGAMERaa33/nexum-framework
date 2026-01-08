import 'dart:io';

import 'package:nexum_framework/nexum.dart';

enum LoggerType {
  log,
  debug,
  warn,
  error,
}

class Logger {
  const Logger._();

  static void _print(
      LoggerType type,
      String identifier,
      String message,
  ) {
    if(!Nexum.initialized || Nexum.instance.release) return;
    final now = DateTime.now();

    final timestamp = now.toIso8601String().replaceFirst('T', ' ').substring(0, 23);

    stderr.writeln('[$timestamp] [${type.name.toUpperCase()}] [Framework/$identifier] - $message');
  }

  static void log(String identifier, String message) {
    _print(LoggerType.log, identifier, message);
  }

  static void debug(String identifier, String message) {
    _print(LoggerType.debug, identifier, message);
  }

  static void warn(String identifier, String message) {
    _print(LoggerType.warn, identifier, message);
  }

  static void error(String identifier, String message) {
    _print(LoggerType.error, identifier, message);
  }
}
