import 'package:logging/logging.dart' as pkg_logging;
import 'log_level.dart';

/// A standardized logger for the DartStream framework.
/// 
/// This wraps the community-standard `package:logging` to provide
/// a consistent API across all Aortem packages.
class DSLogger {
  final pkg_logging.Logger _internalLogger;
  LogLevel _currentLevel = LogLevel.info;

  /// Creates a new logger with the given [name].
  DSLogger(String name) : _internalLogger = pkg_logging.Logger(name) {
    // Enable hierarchical logging to allow setting levels per logger
    pkg_logging.hierarchicalLoggingEnabled = true;
    _internalLogger.level = _toPackageLevel(_currentLevel);
    
    // Configure default bridge to package:logging
    _internalLogger.onRecord.listen((record) {
      print('${record.level.name.toUpperCase()}: ${record.message}');
    });
  }

  /// Log a message at the [LogLevel.debug] level.
  void debug(String message) => _log(LogLevel.debug, message);

  /// Log a message at the [LogLevel.info] level.
  void info(String message) => _log(LogLevel.info, message);

  /// Log a message at the [LogLevel.warning] level.
  void warning(String message) => _log(LogLevel.warning, message);

  /// Log a message at the [LogLevel.error] level.
  void error(String message) => _log(LogLevel.error, message);

  /// Log a message at the [LogLevel.critical] level.
  void critical(String message) => _log(LogLevel.critical, message);

  void _log(LogLevel level, String message) {
    if (level.index >= _currentLevel.index) {
      final pkgLevel = _toPackageLevel(level);
      _internalLogger.log(pkgLevel, message);
    }
  }

  /// Sets the minimum level required for a log message to be processed.
  set level(LogLevel level) {
    _currentLevel = level;
    _internalLogger.level = _toPackageLevel(level);
  }

  bool _isLevelEnabled(pkg_logging.Level level) {
    return _toLogLevel(level).index >= _currentLevel.index;
  }

  pkg_logging.Level _toPackageLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return pkg_logging.Level.FINE;
      case LogLevel.info:
        return pkg_logging.Level.INFO;
      case LogLevel.warning:
        return pkg_logging.Level.WARNING;
      case LogLevel.error:
        return pkg_logging.Level.SEVERE;
      case LogLevel.critical:
        return pkg_logging.Level.SHOUT;
    }
  }

  LogLevel _toLogLevel(pkg_logging.Level level) {
    if (level <= pkg_logging.Level.FINE) return LogLevel.debug;
    if (level <= pkg_logging.Level.INFO) return LogLevel.info;
    if (level <= pkg_logging.Level.WARNING) return LogLevel.warning;
    if (level <= pkg_logging.Level.SEVERE) return LogLevel.error;
    return LogLevel.critical;
  }
}
