import 'package:logging/logging.dart';
import 'dart:io';

class DsLogger {
  static Logger? _instance;

  static void initialize({
    Level logLevel = Level.INFO,
    String logFilePath = 'app.log',
  }) {
    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((record) {
      final message = '${record.time}: ${record.level.name}: ${record.message}';
      print(message);
      _writeToFile(logFilePath, message);
    });
    _instance = Logger('DsLogger');
  }

  static void _writeToFile(String filePath, String message) {
    File(filePath).writeAsStringSync('$message\n', mode: FileMode.append);
  }

  static void info(String message) => _instance?.info(message);
  static void warning(String message) => _instance?.warning(message);
  static void error(String message) => _instance?.severe(message);
  static void debug(String message) => _instance?.fine(message);
}
