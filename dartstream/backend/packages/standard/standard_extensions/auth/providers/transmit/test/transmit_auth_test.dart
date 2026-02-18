import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart';

void main() {
  group('DSTransmitAuthProvider - Mock Tests', () {
    late DSTransmitAuthProvider provider;

    setUp(() async {
      provider = DSTransmitAuthProvider();
      // Use __dev__ mode to bypass real SDK initialization
      await provider.initialize({'__dev__': true});
    });

    test('initialize accepts dev mode configuration', () async {
      final testProvider = DSTransmitAuthProvider();
      await testProvider.initialize({'__dev__': true});
      expect(testProvider, isNotNull);
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
