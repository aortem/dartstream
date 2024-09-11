import 'package:ds_custom_middleware/app/logging/ds_logger.dart';

String testLogger() {
  DsLogger.initialize();
  DsLogger.info('Test info message');
  DsLogger.warning('Test warning message');
  DsLogger.error('Test error message');
  return 'Logged messages. Check log file for details.';
}
