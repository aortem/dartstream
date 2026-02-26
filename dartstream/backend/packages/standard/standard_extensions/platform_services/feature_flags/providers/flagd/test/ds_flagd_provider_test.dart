import 'package:ds_flagd_provider/ds_flagd_export.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('DSFlagdErrorMapper', () {
    test('maps timeout errors', () {
      final error = DSFlagdErrorMapper.mapError(Exception('request timeout'));
      expect(error.code, equals('timeout'));
    });

    test('maps connection errors', () {
      final error = DSFlagdErrorMapper.mapError(Exception('socket exception'));
      expect(error.code, equals('network_error'));
    });

    test('maps unknown errors', () {
      final error = DSFlagdErrorMapper.mapError(Exception('unexpected'));
      expect(error.code, equals('unknown_error'));
    });
  });
}
