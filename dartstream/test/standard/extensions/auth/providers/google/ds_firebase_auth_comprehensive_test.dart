import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/firebase/lib/ds_firebase_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

/// Mock Firebase Auth Provider for testing without real Firebase setup
class MockFirebaseAuthProvider implements DSAuthProvider {
  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _credentials = {};

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
    print('Mock Firebase Auth Provider initialized');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_credentials[username] == password) {
      _currentUser = _users[username];
      print('Mock sign in successful for: $username');
    } else {
      throw DSAuthError('Invalid credentials');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    print('Mock sign out successful');
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    final user = _users[userId];
    if (user == null) {
      throw DSAuthError('User not found: $userId');
    }
    return user;
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }
    return _currentUser!;
  }

  @override
  Future<void> createAccount(String email, String password, {String? displayName}) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_users.containsKey(email)) {
      throw DSAuthError('User already exists');
    }
    
    final user = DSAuthUser(
      id: 'mock_${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'Mock User',
    );
    
    _users[email] = user;
    _credentials[email] = password;
    print('Mock account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (token == null) return _currentUser != null;
    return token.startsWith('mock_token_') && _currentUser != null;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in');
    }
    return 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Login success hook called for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('Logout hook called');
  }
}

void main() {
  group('Enhanced Firebase Auth Provider Tests', () {
    late MockFirebaseAuthProvider mockProvider;
    late DSAuthManager authManager;

    setUp(() async {
      mockProvider = MockFirebaseAuthProvider();
      
      // Initialize the provider
      await mockProvider.initialize({
        'projectId': 'test-project',
        'apiKey': 'test-api-key',
      });
      
      // Register with auth manager
      DSAuthManager.registerProvider('firebase', mockProvider);
      authManager = DSAuthManager('firebase');
    });

    tearDown(() {
      // Clean up between tests
      DSAuthManager.enableDebugging = false;
    });

    group('Authentication Flow Tests', () {
      test('Complete Authentication Flow', () async {
        // Enable debugging for detailed logs
        DSAuthManager.enableDebugging = true;
        
        // 1. Create a new account
        await authManager.createAccount(
          'test@example.com', 
          'password123',
          displayName: 'Test User',
        );

        // 2. Sign in with the created account
        await authManager.signIn('test@example.com', 'password123');

        // 3. Get current user
        final currentUser = await authManager.getCurrentUser();
        expect(currentUser.email, equals('test@example.com'));
        expect(currentUser.displayName, equals('Test User'));

        // 4. Verify token
        final isValidToken = await authManager.verifyToken();
        expect(isValidToken, isTrue);

        // 5. Refresh token
        final newToken = await authManager.refreshToken('mock_refresh_token');
        expect(newToken, startsWith('mock_token_'));

        // 6. Sign out
        await authManager.signOut();

        // 7. Verify sign out worked
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Invalid Credentials Test', () async {
        await authManager.createAccount('user@test.com', 'correctpass');
        
        expect(
          () => authManager.signIn('user@test.com', 'wrongpass'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Duplicate Account Creation', () async {
        await authManager.createAccount('duplicate@test.com', 'pass123');
        
        expect(
          () => authManager.createAccount('duplicate@test.com', 'pass456'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Provider Management Tests', () {
      test('Provider Registration and Retrieval', () {
        // Test that provider was registered correctly
        expect(authManager, isNotNull);
        
        // Test metadata if available
        final metadata = authManager.getProviderMetadata('firebase');
        print('Provider metadata: $metadata');
      });

      test('Unregistered Provider Error', () {
        expect(
          () => DSAuthManager('nonexistent'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Operations Without Initialization', () async {
        final uninitializedProvider = MockFirebaseAuthProvider();
        
        expect(
          () => uninitializedProvider.signIn('test@email.com', 'pass'),
          throwsA(isA<Exception>()),
        );
      });

      test('User Not Found', () async {
        expect(
          () => authManager.getUser('nonexistent_user_id'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Token Operations Without Sign In', () async {
        expect(
          () => authManager.refreshToken('invalid_token'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Security Tests', () {
      test('Token Validation', () async {
        await authManager.createAccount('security@test.com', 'pass123');
        await authManager.signIn('security@test.com', 'pass123');
        
        // Valid token
        final validToken = await authManager.verifyToken();
        expect(validToken, isTrue);
        
        // Invalid token format
        final invalidToken = await mockProvider.verifyToken('invalid_format');
        expect(invalidToken, isFalse);
      });
    });
  });

  group('Firebase Auth Provider Integration Tests', () {
    test('Real Firebase Provider Initialization', () {
      // Test the actual DSFirebaseAuthProvider class
      final firebaseProvider = DSFirebaseAuthProvider(
        projectId: 'test-project-id',
        privateKeyPath: 'test-key.json',
        apiKey: 'test-api-key',
      );

      expect(firebaseProvider.projectId, equals('test-project-id'));
      expect(firebaseProvider.privateKeyPath, equals('test-key.json'));
      expect(firebaseProvider.apiKey, equals('test-api-key'));
    });

    test('Factory Pattern Singleton', () {
      final provider1 = DSFirebaseAuthProvider(
        projectId: 'test',
        privateKeyPath: 'key.json',
        apiKey: 'key',
      );
      
      final provider2 = DSFirebaseAuthProvider(
        projectId: 'test2',
        privateKeyPath: 'key2.json',
        apiKey: 'key2',
      );

      // Should return the same instance due to singleton pattern
      expect(identical(provider1, provider2), isTrue);
    });
  });
}
