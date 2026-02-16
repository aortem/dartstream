import 'package:test/test.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_auth0_auth_provider/ds_auth0_auth_export.dart';

void main() {
  group('DSAuth0AuthProvider', () {
    late DSAuth0AuthProvider provider;

    setUp(() async {
      provider = DSAuth0AuthProvider(
        domain: 'example.auth0.com',
        clientId: 'test-client',
        clientSecret: 'test-secret',
        audience: 'https://api.example.com',
      );

      await provider.initialize({});
    });

    test('initializes successfully', () {
      expect(provider, isNotNull);
    });

    test('getCurrentUser throws when not signed in', () async {
      expect(
        () => provider.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('verifyToken returns false when no token exists', () async {
      final valid = await provider.verifyToken();
      expect(valid, isFalse);
    });

    test('refreshToken throws when no refresh token exists', () async {
      expect(
        () => provider.refreshToken(null),
        throwsA(isA<DSAuthError>()),
      );
    });
  });
}
