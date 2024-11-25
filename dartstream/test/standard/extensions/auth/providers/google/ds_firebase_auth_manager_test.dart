import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../../dartstream_backend/packages/standard/extensions/auth/providers/google/lib/ds_firebase_auth_provider.dart';

void main() {
  group('DSFirebaseAuthProvider Integration Tests', () {
    late DSFirebaseAuthProvider firebaseAuthProvider;

    setUp(() {
      firebaseAuthProvider = DSFirebaseAuthProvider(
        projectId: 'test_project',
        privateKeyPath: 'test_key.json',
      );
      DSAuthManager.registerProvider('Firebase', firebaseAuthProvider);
    });

    test('Register and Retrieve Firebase Provider', () {
      final authManager = DSAuthManager('Firebase');
      expect(authManager, isNotNull);
    });

    test('Sign In Through Firebase Provider', () async {
      final authManager = DSAuthManager('Firebase');
      await authManager.signIn('test_user', 'test_password');
      print("Successfully signed in through Firebase provider");
    });

    test('Unregistered Firebase Provider Throws Error', () {
      expect(
        () => DSAuthManager('UnknownFirebaseProvider'),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
