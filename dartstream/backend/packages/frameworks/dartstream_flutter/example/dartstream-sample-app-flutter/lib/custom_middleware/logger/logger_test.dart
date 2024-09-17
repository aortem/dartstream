import 'package:ds_custom_middleware/src/logging/ds_logger.dart';

String testLogger() {
  DsLogger.initialize();

  DsLogger.debug('Debug: Testing logger functionality');
  DsLogger.info('Info: This is an informational message');
  DsLogger.warning('Warning: This is a warning message');
  DsLogger.error('Error: This is an error message');

  return 'Logger test completed. Check the console output for log messages.\n'
      'You should see messages with different log levels (Debug, Info, Warning, Error).';
}
