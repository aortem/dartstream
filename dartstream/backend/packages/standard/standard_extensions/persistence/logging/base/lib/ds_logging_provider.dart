/// Logging provider interface for DartStream.
/// This abstract class defines the standard interface for all logging providers.
abstract class DSLoggingProvider {
  /// Initialize the logging provider with configuration settings
  Future<void> initialize(Map<String, dynamic> config);

  /// Log an informational message
  void info(String message, {Map<String, dynamic>? context});

  /// Log a warning message
  void warn(String message, {Map<String, dynamic>? context});

  /// Log an error message, optionally with an exception and stack trace
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  });

  /// Flush any buffered logs
  Future<void> flush();

  /// Dispose of the provider and release any resources
  Future<void> dispose();
}
