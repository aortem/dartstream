import 'package:ds_custom_middleware/src/logging/ds_logger.dart';

String testLogging() {
  DsLogger.initialize();

  DsLogger.debug('This is a debug message');
  DsLogger.info('This is an info message');
  DsLogger.warning('This is a warning message');
  DsLogger.error('This is an error message');

  return 'Logging test completed. Check the console for log messages.';
}
