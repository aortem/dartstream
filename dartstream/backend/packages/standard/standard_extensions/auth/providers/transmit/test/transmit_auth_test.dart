import 'package:test/test.dart';
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart';

void main() {
  group('DSTransmitAuthProvider', () {
    late DSTransmitAuthProvider provider;

    setUp(() async {
      provider = DSTransmitAuthProvider();
      await provider.initialize({
        'apiKey': 'YOUR_API_KEY',
        'serviceId': 'YOUR_SERVICE_ID',
        'region': 'global',
      });
    });

    test('signIn succeeds with valid credentials', () async {
      await provider.signIn('testuser', 'password');
      final user = await provider.getCurrentUser();
      expect(user.email, 'testuser');
      expect(user.customAttributes?['provider'], 'transmit');
    });

    test('getCurrentUser throws if no user signed in', () async {
      expect(
        () async => await provider.getCurrentUser(),
        throwsA(isA<Exception>()),
      );
    });

    test('signOut clears current user', () async {
      await provider.signIn('testuser', 'password');
      expect(await provider.getCurrentUser(), isNotNull);

      await provider.signOut();

      expect(
        () async => await provider.getCurrentUser(),
        throwsA(isA<Exception>()),
      );
    });

    test('refreshToken returns new token', () async {
      await provider.signIn('testuser', 'password');
      final newToken = await provider.refreshToken('old_refresh_token');
      expect(newToken, isNotEmpty);
      expect(newToken, startsWith('mock_access_token'));
    });
  });
}
