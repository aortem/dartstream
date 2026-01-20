import 'package:test/test.dart';
import 'package:ds_stytch_auth_provider/ds_firebase_auth_provider.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

void main() {
  group('DSStytchAuthProvider (mock)', () {
    late DSStytchAuthProvider provider;

    setUp(() async {
      provider = DSStytchAuthProvider();
      await provider.initialize({});
    });

    test('can create and login a user', () async {
      await provider.createAccount('test@mail.com', '123456', displayName: 'Test User');
      await provider.signIn('test@mail.com', '123456');

      final user = await provider.getCurrentUser();
      expect(user.email, 'test@mail.com');
      expect(user.displayName, 'Test User');

      await provider.signOut();
    });

    test('verifyToken returns true for issued token', () async {
      await provider.createAccount('test2@mail.com', 'abcdef');
      await provider.signIn('test2@mail.com', 'abcdef');

      final user = await provider.getCurrentUser();
      final fakeToken = 'stytch-mock-${user.id}';
      final valid = await provider.verifyToken(fakeToken);
      expect(valid, true);

      await provider.signOut();
    });
  });
}
