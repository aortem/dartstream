// ds_logging.dart

class DartstreamLogger {
  /// Logs a message with the specified level.
  void log(String message, {String level = 'info'}) {
    final logOutput = '[${DateTime.now().toIso8601String()}][$level] $message';
    print(logOutput);
  }
}
