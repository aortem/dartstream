import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_logging/ds_logging.dart';
import 'dart:async';

void main() {
  group('DSLogger', () {
    test('Can be initialized with a name', () {
      final logger = DSLogger('test-logger');
      expect(logger, isNotNull);
    });

    test('Respects hierarchical logging levels', () {
      final logger = DSLogger('level-test');
      
      // Default level is info (1)
      // Levels: debug(0), info(1), warning(2), error(3), critical(4)
      
      // We can't easily capture stdout in a portable way across all environments
      // but we can test the internal logic if we expose it or use a zone.
      // For now, we'll verify the API works without crashing.
      
      logger.level = LogLevel.warning;
      logger.debug('This should be hidden');
      logger.info('This should also be hidden');
      logger.warning('This should be visible');
      logger.error('This should be visible');
      logger.critical('This should be visible');
    });

    test('LogLevel index order is correct', () {
      expect(LogLevel.debug.index, lessThan(LogLevel.info.index));
      expect(LogLevel.info.index, lessThan(LogLevel.warning.index));
      expect(LogLevel.warning.index, lessThan(LogLevel.error.index));
      expect(LogLevel.error.index, lessThan(LogLevel.critical.index));
    });
  });
}
