import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/auth0/lib/ds_auth0_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

/// Mock Auth0 Auth Provider for testing without real Auth0 setup
class MockAuth0AuthProvider implements DSAuthProvider {
  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _credentials = {};
  final Map<String, String> _refreshTokens = {};

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
    print('Mock Auth0 Auth Provider initialized');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_credentials[username] == password) {
      _currentUser = _users[username];
      print('Mock Auth0 sign in successful for: $username');
    } else {
      throw DSAuthError('Invalid credentials');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    print('Mock Auth0 sign out successful');
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError('User not found: $userId'),
    );
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
      id: 'auth0|${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'Auth0 User',
      customAttributes: {
        'provider': 'auth0',
        'email_verified': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    
    _users[email] = user;
    _credentials[email] = password;
    _refreshTokens[email] = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
    print('Mock Auth0 account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (token == null) return _currentUser != null;
    
    // Mock JWT token validation
    if (token.startsWith('eyJ') && token.contains('.') && _currentUser != null) {
      return true;
    }
    return false;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in');
    }
    
    // Mock token refresh
    if (refreshToken.startsWith('refresh_token_')) {
      return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.${DateTime.now().millisecondsSinceEpoch}';
    }
    
    throw DSAuthError('Invalid refresh token');
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Auth0 login success hook called for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('Auth0 logout hook called');
  }
}

void main() {
  group('Enhanced Auth0 Auth Provider Tests', () {
    late MockAuth0AuthProvider mockProvider;
    late DSAuthManager authManager;

    setUp(() async {
      mockProvider = MockAuth0AuthProvider();
      
      // Initialize the provider
      await mockProvider.initialize({
        'domain': 'test-domain.auth0.com',
        'clientId': 'test_client_id',
        'clientSecret': 'test_client_secret',
        'audience': 'https://test-api.example.com',
      });
      
      // Register with auth manager
      DSAuthManager.registerProvider(
        'auth0',
        mockProvider,
        DSAuthProviderMetadata(
          type: 'Auth0',
          region: 'us-west-2',
          clientId: 'test_client_id',
        ),
      );
      authManager = DSAuthManager('auth0');
    });

    tearDown(() {
      // Clean up between tests
      DSAuthManager.enableDebugging = false;
      DSAuthManager.clearProviders();
    });

    group('Authentication Flow Tests', () {
      test('Complete Auth0 Authentication Flow', () async {
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
        expect(currentUser.id, startsWith('auth0|'));
        expect(currentUser.customAttributes?['provider'], equals('auth0'));
        expect(currentUser.customAttributes?['email_verified'], isTrue);

        // 4. Verify JWT token
        final isValidToken = await authManager.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.test');
        expect(isValidToken, isTrue);

        // 5. Refresh token
        final newToken = await authManager.refreshToken('refresh_token_123456');
        expect(newToken, startsWith('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.'));

        // 6. Sign out
        await authManager.signOut();

        // 7. Verify sign out worked
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Auth0 JWT Token Validation', () async {
        await authManager.createAccount('jwt@test.com', 'password123');
        await authManager.signIn('jwt@test.com', 'password123');
        
        // Valid JWT format
        final validJWT = await authManager.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.payload.signature');
        expect(validJWT, isTrue);
        
        // Invalid JWT format
        final invalidJWT = await authManager.verifyToken('not.a.jwt');
        expect(invalidJWT, isFalse);
        
        // Empty token
        final emptyToken = await authManager.verifyToken('');
        expect(emptyToken, isFalse);
      });

      test('Auth0 User Attributes', () async {
        await authManager.createAccount(
          'attributes@test.com',
          'password123',
          displayName: 'Attributes User',
        );
        
        final user = await authManager.getUser('auth0|attributes_test_com');
        expect(user.customAttributes?['provider'], equals('auth0'));
        expect(user.customAttributes?['email_verified'], isTrue);
        expect(user.customAttributes?['created_at'], isNotNull);
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
        
        // Test metadata
        final metadata = authManager.getProviderMetadata('auth0');
        expect(metadata, isNotNull);
        expect(metadata!.type, equals('Auth0'));
        expect(metadata.region, equals('us-west-2'));
        expect(metadata.clientId, equals('test_client_id'));
        print('Auth0 Provider metadata: ${metadata.type}, ${metadata.region}, ${metadata.clientId}');
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
        final uninitializedProvider = MockAuth0AuthProvider();
        
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

      test('Invalid Refresh Token', () async {
        await authManager.createAccount('tokentest@example.com', 'pass123');
        await authManager.signIn('tokentest@example.com', 'pass123');
        
        expect(
          () => authManager.refreshToken('invalid_refresh_token'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Security Tests', () {
      test('Token Validation Edge Cases', () async {
        await authManager.createAccount('security@test.com', 'pass123');
        await authManager.signIn('security@test.com', 'pass123');
        
        // Valid JWT token
        final validToken = await authManager.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.test');
        expect(validToken, isTrue);
        
        // Invalid token format
        final invalidToken = await mockProvider.verifyToken('invalid_format');
        expect(invalidToken, isFalse);
        
        // Null token when signed in
        final nullToken = await authManager.verifyToken(null);
        expect(nullToken, isTrue);
      });

      test('User ID Format Validation', () async {
        await authManager.createAccount('format@test.com', 'pass123');
        
        final user = await authManager.getUser('auth0|format_test_com');
        expect(user.id, startsWith('auth0|'));
        expect(user.id, contains('format_test_com'));
      });
    });

    group('Lifecycle Hook Tests', () {
      test('Login Success Hook', () async {
        await authManager.createAccount('hooks@test.com', 'pass123');
        
        // This should trigger the onLoginSuccess hook
        await authManager.signIn('hooks@test.com', 'pass123');
        
        final user = await authManager.getCurrentUser();
        await mockProvider.onLoginSuccess(user);
        
        // Hook should log success message
        expect(user.email, equals('hooks@test.com'));
      });

      test('Logout Hook', () async {
        await authManager.createAccount('logout@test.com', 'pass123');
        await authManager.signIn('logout@test.com', 'pass123');
        
        await authManager.signOut();
        await mockProvider.onLogout();
        
        // Hook should log logout message
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });
    });
  });

  group('Auth0 Auth Provider Integration Tests', () {
    test('Real Auth0 Provider Initialization', () {
      // Test the actual DSAuth0AuthProvider class
      final auth0Provider = DSAuth0AuthProvider(
        domain: 'test-domain.auth0.com',
        clientId: 'test_client_id',
        clientSecret: 'test_client_secret',
        audience: 'https://test-api.example.com',
      );

      expect(auth0Provider.domain, equals('test-domain.auth0.com'));
      expect(auth0Provider.clientId, equals('test_client_id'));
      expect(auth0Provider.clientSecret, equals('test_client_secret'));
      expect(auth0Provider.audience, equals('https://test-api.example.com'));
    });

    test('Factory Pattern Singleton', () {
      final provider1 = DSAuth0AuthProvider(
        domain: 'test1.auth0.com',
        clientId: 'client1',
        clientSecret: 'secret1',
        audience: 'https://api1.example.com',
      );
      
      final provider2 = DSAuth0AuthProvider(
        domain: 'test2.auth0.com',
        clientId: 'client2',
        clientSecret: 'secret2',
        audience: 'https://api2.example.com',
      );

      // Should return the same instance due to singleton pattern
      expect(identical(provider1, provider2), isTrue);
    });

    test('Auth0 Domain Validation', () {
      final provider = DSAuth0AuthProvider(
        domain: 'my-app.auth0.com',
        clientId: 'client_id',
        clientSecret: 'client_secret',
        audience: 'https://api.myapp.com',
      );

      expect(provider.domain, contains('.auth0.com'));
      expect(provider.audience, startsWith('https://'));
    });
  });
}
