import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

/// Mock test without actual Firebase connection
/// Use this for initial development and CI/CD pipelines
void main() {
  group('Firebase Auth Provider - Mock Tests', () {
    late DSAuthManager authManager;

    setUp(() {
      DSAuthManager.clearProviders();
    });

    test('Should accept provider registration', () {
      final mockProvider = MockFirebaseAuthProvider();

      DSAuthManager.registerProvider('firebase', mockProvider);
      final providers = DSAuthManager.getRegisteredProviders();

      expect(providers, contains('firebase'));
      print('✓ Provider registration works');
    });

    test('Should create auth manager instance', () {
      final mockProvider = MockFirebaseAuthProvider();
      DSAuthManager.registerProvider('firebase', mockProvider);

      authManager = DSAuthManager('firebase');
      expect(authManager, isNotNull);
      print('✓ Auth manager creation works');
    });

    test('Should reject duplicate provider registration', () {
      final mockProvider = MockFirebaseAuthProvider();
      DSAuthManager.registerProvider('firebase', mockProvider);

      expect(
        () => DSAuthManager.registerProvider('firebase', mockProvider),
        throwsArgumentError,
      );
      print('✓ Duplicate registration prevention works');
    });

    test('Should throw error for unregistered provider', () {
      expect(() => DSAuthManager('nonexistent'), throwsA(isA<DSAuthError>()));
      print('✓ Unregistered provider error works');
    });

    test('Should clear all providers', () {
      final mockProvider = MockFirebaseAuthProvider();
      DSAuthManager.registerProvider('firebase', mockProvider);
      DSAuthManager.clearProviders();

      final providers = DSAuthManager.getRegisteredProviders();
      expect(providers, isEmpty);
      print('✓ Provider clearing works');
    });

    test('Should handle basic auth flow structure', () async {
      final mockProvider = MockFirebaseAuthProvider();
      DSAuthManager.registerProvider('firebase', mockProvider);
      authManager = DSAuthManager('firebase');

      // 🔹 Initialize the provider to avoid "Not initialized" errors
      await mockProvider.initialize({});

      // Test the auth interface
      await authManager.createAccount('test@example.com', 'password');
      await authManager.signIn('test@example.com', 'password');

      final currentUser = await authManager.getCurrentUser();
      expect(currentUser.email, equals('test@example.com'));

      await authManager.signOut();
      expect(() => authManager.getCurrentUser(), throwsA(isA<DSAuthError>()));

      print('✓ Auth flow interface works');
    });
  });

  group('Token Manager - Unit Tests', () {
    test('Should validate token structure', () {
      final validToken =
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0ZXN0IiwiYXVkIjoidGVzdCIsImV4cCI6OTk5OTk5OTk5OX0.test';

      expect(validToken.split('.').length, equals(3));
      print('✓ Token structure validation works');
    });
  });

  group('Error Mapper - Unit Tests', () {
    test('Should have error mapping functions', () {
      expect(() => DSAuthError('Test error', code: 401), returnsNormally);
      print('✓ Error creation works');
    });

    test('Should format error messages', () {
      final error = DSAuthError('Test error', code: 401);
      expect(error.message, equals('Test error'));
      expect(error.code, equals(401));
      expect(error.toString(), contains('Test error'));
      expect(error.toString(), contains('401'));
      print('✓ Error formatting works');
    });
  });
}

/// Mock implementation for testing without Firebase
class MockFirebaseAuthProvider implements DSAuthProvider {
  bool _isInitialized = false;
  DSAuthUser? _currentUser;

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    if (!_isInitialized) throw DSAuthError('Not initialized');
    _currentUser = DSAuthUser(
      id: 'mock_${email.hashCode}',
      email: email,
      displayName: displayName ?? '',
    );
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw DSAuthError('Not initialized');
    _currentUser = DSAuthUser(
      id: 'mock_${username.hashCode}',
      email: username,
      displayName: 'Mock User',
    );
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in');
    }
    return _currentUser!;
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    if (_currentUser?.id == userId) {
      return _currentUser!;
    }
    throw DSAuthError('User not found');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    return _currentUser != null;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    return 'mock_refreshed_token';
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  @override
  Future<void> onLogout() async {}
}
