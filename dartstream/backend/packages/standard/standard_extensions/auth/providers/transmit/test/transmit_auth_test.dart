import 'package:test/test.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart'; // <- fixed


void main() {
  group('DSTransmitAuthProvider', () {
    final provider = DSTransmitAuthProvider();

    setUp(() async {
      await provider.initialize({
        'apiKey': 'YOUR_API_KEY',
        'serviceId': 'YOUR_SERVICE_ID',
        'region': 'global',
      });
    });

    test('signIn throws if wrong credentials', () async {
      expect(
        () async => await provider.signIn('wronguser', 'wrongpass'),
        throwsA(isA<Exception>()),
      );
    });

    test('getCurrentUser throws if no user signed in', () async {
      expect(
        () async => await provider.getCurrentUser(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
