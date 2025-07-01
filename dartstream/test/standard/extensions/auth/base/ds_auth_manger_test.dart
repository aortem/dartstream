/*
This file focuses solely on DSAuthManager as a standalone component.
Uses a mock provider instead of the real DSFirebaseAuthProvider. 
*/

import 'package:test/test.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../dartstream_backend/packages/standard/extensions/auth/base/lib/ds_auth_provider.dart';

class MockAuthProvider implements DSAuthProvider {
  @override
  Future<void> initialize(Map<String, dynamic> config) async {}

  @override
  Future<void> signIn(String username, String password) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<DSAuthUser> getUser(String userId) async {
    return DSAuthUser(
        id: userId, email: 'test@example.com', displayName: 'Test User');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    return token == 'valid_token';
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    return 'new_token';
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    return DSAuthUser(
        id: 'current_user', email: 'current@example.com', displayName: 'Current User');
  }

  @override
  Future<void> createAccount(String email, String password, {String? displayName}) async {}

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  @override
  Future<void> onLogout() async {}
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
    });    test('Unregistered Provider Throws Error', () {
      expect(
        () => DSAuthManager('UnknownProvider'),
        throwsA(isA<DSAuthError>()),
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
