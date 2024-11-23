import 'package:test/test.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_provider.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/providers/google/lib/ds_firebase_auth_provider.dart';

void main() {
  group('DSAuthManager Tests', () {
    late DSFirebaseAuthProvider firebaseAuthProvider;

    setUp(() {
      firebaseAuthProvider = DSFirebaseAuthProvider(
        projectId: 'test_project',
        privateKeyPath: 'test_key.json',
      );
      DSAuthManager.registerProvider('Firebase', firebaseAuthProvider);
    });

    test('Register and Retrieve Provider', () {
      final authManager = DSAuthManager('Firebase');
      expect(authManager, isNotNull);
    });

    test('Sign In Through Manager', () async {
      final authManager = DSAuthManager('Firebase');
      await authManager.signIn('test_user', 'test_password');
      expect(firebaseAuthProvider.lastSignInUsername, equals('test_user'));
    });

    test('Unregistered Provider', () {
      expect(
        () => DSAuthManager('UnknownProvider'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('Duplicate Provider Registration', () {
      expect(
        () => DSAuthManager.registerProvider('Firebase', firebaseAuthProvider),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
