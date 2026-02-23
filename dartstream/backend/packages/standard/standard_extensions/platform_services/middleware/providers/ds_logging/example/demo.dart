import 'package:ds_logging/ds_logging.dart';

void main() {
  final logger = DSLogger('demo-logger');
  
  print('--- Level: Info (Default) ---');
  logger.level = LogLevel.info;
  logger.debug('Hidden debug');
  logger.info('Visible info');
  logger.warning('Visible warning');
  
  print('\n--- Level: Error ---');
  logger.level = LogLevel.error;
  logger.warning('Hidden warning');
  logger.error('Visible error');
  logger.critical('Visible critical');
  
  print('\n--- Level: Debug ---');
  logger.level = LogLevel.debug;
  logger.debug('Visible debug');
  logger.info('Visible info');
}
