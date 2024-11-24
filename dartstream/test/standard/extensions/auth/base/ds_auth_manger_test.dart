/*
This file focuses solely on DSAuthManager as a standalone component.
Uses a mock provider instead of the real DSFirebaseAuthProvider. 
*/

import 'package:test/test.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_provider.dart';

class MockAuthProvider implements DSAuthProvider {
  @override
  Future<void> signIn(String username, String password) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<DSUser> getUser(String userId) async {
    return DSUser(
        id: userId, email: 'test@example.com', displayName: 'Test User');
  }

  @override
  Future<bool> verifyToken(String token) async {
    return token == 'valid_token';
  }
}

void main() {
  group('DSAuthManager Tests', () {
    late MockAuthProvider mockProvider;

    setUp(() {
      mockProvider = MockAuthProvider();
      DSAuthManager.registerProvider('MockProvider', mockProvider);
    });

    test('Register and Retrieve Provider', () {
      final authManager = DSAuthManager('MockProvider');
      expect(authManager, isNotNull);
    });

    test('Sign In Through Manager', () async {
      final authManager = DSAuthManager('MockProvider');
      await authManager.signIn('test_user', 'test_password');
    });

    test('Unregistered Provider Throws Error', () {
      expect(
        () => DSAuthManager('UnknownProvider'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('Duplicate Provider Registration', () {
      expect(
        () => DSAuthManager.registerProvider('MockProvider', mockProvider),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
