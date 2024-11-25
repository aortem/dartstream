import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/extensions/auth/providers/google/lib/ds_firebase_auth_provider.dart';

void main() {
  group('DSFirebaseAuthProvider Tests', () {
    late DSFirebaseAuthProvider firebaseAuthProvider;

    setUp(() {
      firebaseAuthProvider = DSFirebaseAuthProvider(
        projectId: 'test_project',
        privateKeyPath: 'test_key.json',
      );
    });

    test('Initialization', () {
      expect(firebaseAuthProvider.projectId, equals('test_project'));
      expect(firebaseAuthProvider.privateKeyPath, equals('test_key.json'));
    });

    test('Sign In', () async {
      await firebaseAuthProvider.signIn('test_user', 'test_password');
      print("Successfully signed in with test_user");
    });

    test('Sign Out', () async {
      await firebaseAuthProvider.signOut();
      print("Successfully signed out");
    });

    test('Get User', () async {
      final user = await firebaseAuthProvider.getUser('user123');
      expect(user.id, equals('firebase_user123'));
      expect(user.email, equals('user@example.com'));
      expect(user.displayName, equals('Firebase User'));
    });

    test('Verify Valid Token', () async {
      final isValid =
          await firebaseAuthProvider.verifyToken('valid_firebase_token');
      expect(isValid, isTrue);
    });

    test('Verify Invalid Token', () async {
      final isValid = await firebaseAuthProvider.verifyToken('invalid_token');
      expect(isValid, isFalse);
    });
  });
}
