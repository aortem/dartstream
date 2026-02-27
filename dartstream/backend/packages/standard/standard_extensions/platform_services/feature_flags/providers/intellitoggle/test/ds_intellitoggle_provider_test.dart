import 'package:ds_intellitoggle_provider/ds_intellitoggle_export.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('DSIntelliToggleProvider', () {
    // ----------------------------------------------------------
    // ERROR HANDLING TESTS (don't need API)
    // ----------------------------------------------------------

    group('DSIntelliToggleErrorMapper', () {
      test('should map unauthorized error correctly', () {
        final error = DSIntelliToggleErrorMapper.mapError(
          Exception('401 unauthorized'),
        );
        expect(error.code, equals('unauthorized'));
      });

      test('should map not found error correctly', () {
        final error = DSIntelliToggleErrorMapper.mapError(
          Exception('404 not found'),
        );
        expect(error.code, equals('flag_not_found'));
      });

      test('should map rate limit error correctly', () {
        final error = DSIntelliToggleErrorMapper.mapError(
          Exception('429 rate limit exceeded'),
        );
        expect(error.code, equals('rate_limit_exceeded'));
      });

      test('should map timeout error correctly', () {
        final error = DSIntelliToggleErrorMapper.mapError(
          Exception('timeout'),
        );
        expect(error.code, equals('timeout'));
      });

      test('should map unknown error correctly', () {
        final error = DSIntelliToggleErrorMapper.mapError(
          Exception('something went wrong'),
        );
        expect(error.code, equals('unknown_error'));
      });
    });

    // ----------------------------------------------------------
    // CONFIG TESTS (don't need API)
    // ----------------------------------------------------------

    group('DSIntelliToggleConfig', () {
      test('should create default config', () {
        final config = DSIntelliToggleConfig();
        expect(config.enableLogging, equals(false));
        expect(config.maxRetries, equals(3));
        expect(config.enablePolling, equals(true));
      });

      test('should create production config', () {
        final config = DSIntelliToggleConfig.production();
        expect(
          config.baseUri,
          equals(Uri.parse('https://api.intellitoggle.com')),
        );
        expect(config.enableLogging, equals(false));
      });

      test('should create development config', () {
        final config = DSIntelliToggleConfig.development();
        expect(config.enableLogging, equals(true));
        expect(config.maxRetries, equals(1));
      });
    });
  });
}