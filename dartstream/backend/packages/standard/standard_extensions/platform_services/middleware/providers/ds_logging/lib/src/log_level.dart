/// Standardized log levels for DartStream.
enum LogLevel {
  /// Debugging information, usually only useful for developers.
  debug,
  
  /// General information about the application flow.
  info,
  
  /// Potentially harmful situations that should be noted.
  warning,
  
  /// Error events that might allow the application to continue running.
  error,
  
  /// Severe error events that will lead the application to abort.
  critical,
}
