import 'package:test/test.dart';

// Mock implementations for Auth0 testing - these would normally come from ds_auth_base package

/// Interface for all Auth Providers
abstract class DSAuthProvider {
  Future<void> initialize(Map<String, dynamic> config);
  Future<void> signIn(String username, String password);
  Future<void> signOut();
  Future<DSAuthUser> getUser(String userId);
  Future<bool> verifyToken([String? token]);
  Future<String> refreshToken(String refreshToken);
  Future<DSAuthUser> getCurrentUser();
  Future<void> createAccount(String email, String password, {String? displayName});
  Future<void> onLoginSuccess(DSAuthUser user) async {}
  Future<void> onLogout() async {}
}

/// Standardized User model
class DSAuthUser {
  final String id;
  final String email;
  final String displayName;
  final Map<String, dynamic>? customAttributes;

  DSAuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.customAttributes,
  });

  @override
  String toString() => 'DSAuthUser(id: $id, email: $email, displayName: $displayName)';
}

/// Auth Error class
class DSAuthError implements Exception {
  final String message;
  final int? code;

  DSAuthError(this.message, {this.code});

  @override
  String toString() => 'DSAuthError: $message (Code: $code)';
}

/// Auth0 Provider Manager
class DSAuthManager {
  static final Map<String, DSAuthProvider> _registeredProviders = {};
  static bool enableDebugging = false;

  static void log(String message) {
    if (enableDebugging) {
      print('DSAuthManager: $message');
    }
  }

  static void registerProvider(String name, DSAuthProvider provider) {
    _registeredProviders[name] = provider;
    log('Registered provider: $name');
  }

  late DSAuthProvider _provider;

  DSAuthManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSAuthError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  Future<DSAuthUser> getCurrentUser() => _provider.getCurrentUser();
  Future<void> createAccount(String email, String password, {String? displayName}) =>
      _provider.createAccount(email, password, displayName: displayName);
  Future<void> signIn(String username, String password) => _provider.signIn(username, password);
  Future<void> signOut() => _provider.signOut();
  Future<DSAuthUser> getUser(String userId) => _provider.getUser(userId);
  Future<bool> verifyToken([String? token]) => _provider.verifyToken(token);
  Future<String> refreshToken(String refreshToken) => _provider.refreshToken(refreshToken);
}

/// Standalone Auth0 Provider Implementation
class StandaloneAuth0Provider implements DSAuthProvider {
  final String domain;
  final String clientId;
  final String clientSecret;
  final String audience;

  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _passwords = {};
  final Map<String, String> _tokens = {};

  StandaloneAuth0Provider({
    required this.domain,
    required this.clientId,
    required this.clientSecret,
    required this.audience,
  });

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
    print('Standalone Auth0 Provider initialized with domain: $domain');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_passwords[username] == password) {
      _currentUser = _users[username];
      _tokens[username] = _generateJWT(username);
      print('Auth0 sign in successful for: $username');
    } else {
      throw DSAuthError('Invalid Auth0 credentials');
    }
  }

  @override
  Future<void> signOut() async {
    if (_currentUser != null) {
      _tokens.remove(_currentUser!.email);
      _currentUser = null;
      print('Auth0 sign out successful');
    }
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError('Auth0 user not found: $userId'),
    );
    return user;
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No Auth0 user is currently signed in');
    }
    return _currentUser!;
  }

  @override
  Future<void> createAccount(String email, String password, {String? displayName}) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_users.containsKey(email)) {
      throw DSAuthError('Auth0 user already exists');
    }
    
    final user = DSAuthUser(
      id: 'auth0|${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'Auth0 User',
      customAttributes: {
        'provider': 'auth0',
        'domain': domain,
        'email_verified': true,
        'created_at': DateTime.now().toIso8601String(),
        'last_login': null,
        'login_count': 0,
      },
    );
    
    _users[email] = user;
    _passwords[email] = password;
    print('Auth0 account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (token == null) return _currentUser != null;
    
    // Mock JWT validation for Auth0
    if (token.startsWith('eyJ') && token.contains('.')) {
      final email = _currentUser?.email;
      if (email != null && _tokens[email] == token) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (_currentUser == null) {
      throw DSAuthError('No Auth0 user signed in');
    }
    
    // Mock refresh token for Auth0
    if (refreshToken.startsWith('auth0_refresh_')) {
      // Add a small delay to ensure different timestamp
      await Future.delayed(Duration(milliseconds: 10));
      final newToken = _generateJWT(_currentUser!.email);
      _tokens[_currentUser!.email] = newToken;
      return newToken;
    }
    
    throw DSAuthError('Invalid Auth0 refresh token');
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // Update login stats
    if (user.customAttributes != null) {
      user.customAttributes!['last_login'] = DateTime.now().toIso8601String();
      user.customAttributes!['login_count'] = 
          (user.customAttributes!['login_count'] ?? 0) + 1;
    }
    print('Auth0 login success hook called for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('Auth0 logout hook called');
  }

  String _generateJWT(String email) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.${base64Encode(email)}.${timestamp}';
  }

  String base64Encode(String input) {
    // Simple base64 encoding simulation
    return input.replaceAll(' ', '').replaceAll('@', 'AT').replaceAll('.', 'DOT');
  }
}

void main() {
  group('Standalone Auth0 Provider Tests', () {
    late StandaloneAuth0Provider auth0Provider;
    late DSAuthManager authManager;

    setUp(() async {
      auth0Provider = StandaloneAuth0Provider(
        domain: 'test-app.auth0.com',
        clientId: 'test_client_id_123',
        clientSecret: 'test_client_secret_456',
        audience: 'https://api.test-app.com',
      );

      await auth0Provider.initialize({
        'domain': 'test-app.auth0.com',
        'clientId': 'test_client_id_123',
      });

      DSAuthManager.registerProvider('auth0', auth0Provider);
      authManager = DSAuthManager('auth0');
    });

    group('Basic Auth0 Operations', () {
      test('Provider Initialization', () {
        expect(auth0Provider.domain, equals('test-app.auth0.com'));
        expect(auth0Provider.clientId, equals('test_client_id_123'));
        expect(auth0Provider.clientSecret, equals('test_client_secret_456'));
        expect(auth0Provider.audience, equals('https://api.test-app.com'));
      });

      test('Account Creation and Sign In', () async {
        await authManager.createAccount(
          'standalone@auth0.com',
          'securepassword123',
          displayName: 'Standalone User',
        );

        await authManager.signIn('standalone@auth0.com', 'securepassword123');

        final user = await authManager.getCurrentUser();
        expect(user.email, equals('standalone@auth0.com'));
        expect(user.displayName, equals('Standalone User'));
        expect(user.id, startsWith('auth0|'));
      });

      test('Auth0 Custom Attributes', () async {
        await authManager.createAccount(
          'attributes@auth0.com',
          'password123',
          displayName: 'Attributes User',
        );

        final user = await authManager.getUser('auth0|attributes_auth0_com');
        expect(user.customAttributes?['provider'], equals('auth0'));
        expect(user.customAttributes?['domain'], equals('test-app.auth0.com'));
        expect(user.customAttributes?['email_verified'], isTrue);
        expect(user.customAttributes?['login_count'], equals(0));
      });

      test('Sign Out and State Management', () async {
        await authManager.createAccount('signout@auth0.com', 'password123');
        await authManager.signIn('signout@auth0.com', 'password123');

        // Verify signed in
        final user = await authManager.getCurrentUser();
        expect(user.email, equals('signout@auth0.com'));

        // Sign out
        await authManager.signOut();

        // Verify signed out
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('JWT Token Management', () {
      test('Token Generation and Validation', () async {
        await authManager.createAccount('jwt@auth0.com', 'password123');
        await authManager.signIn('jwt@auth0.com', 'password123');

        // Token should be valid when signed in
        final isValid = await authManager.verifyToken();
        expect(isValid, isTrue);

        // Get the actual token
        final token = auth0Provider._tokens['jwt@auth0.com'];
        expect(token, isNotNull);
        expect(token!, startsWith('eyJ'));

        // Verify the specific token
        final tokenValid = await authManager.verifyToken(token);
        expect(tokenValid, isTrue);
      });

      test('Token Refresh', () async {
        await authManager.createAccount('refresh@auth0.com', 'password123');
        await authManager.signIn('refresh@auth0.com', 'password123');

        final originalToken = auth0Provider._tokens['refresh@auth0.com'];
        expect(originalToken, isNotNull);

        // Refresh token
        final newToken = await authManager.refreshToken('auth0_refresh_token_123');
        expect(newToken, isNotNull);
        expect(newToken, startsWith('eyJ'));
        expect(newToken, isNot(equals(originalToken)));

        // Verify new token works
        final newTokenValid = await authManager.verifyToken(newToken);
        expect(newTokenValid, isTrue);
      });

      test('Invalid Token Rejection', () async {
        await authManager.createAccount('invalid@auth0.com', 'password123');
        await authManager.signIn('invalid@auth0.com', 'password123');

        // Invalid token formats
        final invalidToken1 = await authManager.verifyToken('invalid_token');
        expect(invalidToken1, isFalse);

        final invalidToken2 = await authManager.verifyToken('eyJ.invalid.format');
        expect(invalidToken2, isFalse);

        final invalidToken3 = await authManager.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.wrong_payload');
        expect(invalidToken3, isFalse);
      });
    });

    group('Error Handling', () {
      test('Invalid Login Credentials', () async {
        await authManager.createAccount('error@auth0.com', 'correctpassword');

        expect(
          () => authManager.signIn('error@auth0.com', 'wrongpassword'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('User Not Found', () async {
        expect(
          () => authManager.getUser('auth0|nonexistent_user'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Duplicate Account Creation', () async {
        await authManager.createAccount('duplicate@auth0.com', 'password123');

        expect(
          () => authManager.createAccount('duplicate@auth0.com', 'password456'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Operations Without Authentication', () async {
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );

        expect(
          () => authManager.refreshToken('some_refresh_token'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Lifecycle Hooks', () {
      test('Login Success Hook Updates', () async {
        await authManager.createAccount('hooks@auth0.com', 'password123');
        await authManager.signIn('hooks@auth0.com', 'password123');

        final user = await authManager.getCurrentUser();
        await auth0Provider.onLoginSuccess(user);

        // Check that login count was updated
        expect(user.customAttributes?['login_count'], equals(1));
        expect(user.customAttributes?['last_login'], isNotNull);
      });

      test('Logout Hook', () async {
        await authManager.createAccount('logout@auth0.com', 'password123');
        await authManager.signIn('logout@auth0.com', 'password123');

        await authManager.signOut();
        await auth0Provider.onLogout();

        // Should be logged out
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Integration Tests', () {
      test('Multiple Users Management', () async {
        // Create multiple users
        await authManager.createAccount('user1@auth0.com', 'password123');
        await authManager.createAccount('user2@auth0.com', 'password456');
        await authManager.createAccount('user3@auth0.com', 'password789');

        // Test each user can sign in
        await authManager.signIn('user1@auth0.com', 'password123');
        final user1 = await authManager.getCurrentUser();
        expect(user1.email, equals('user1@auth0.com'));

        await authManager.signOut();
        await authManager.signIn('user2@auth0.com', 'password456');
        final user2 = await authManager.getCurrentUser();
        expect(user2.email, equals('user2@auth0.com'));

        await authManager.signOut();
        await authManager.signIn('user3@auth0.com', 'password789');
        final user3 = await authManager.getCurrentUser();
        expect(user3.email, equals('user3@auth0.com'));
      });

      test('Session Persistence', () async {
        await authManager.createAccount('session@auth0.com', 'password123');
        await authManager.signIn('session@auth0.com', 'password123');

        // Get user multiple times
        final user1 = await authManager.getCurrentUser();
        final user2 = await authManager.getCurrentUser();
        final user3 = await authManager.getCurrentUser();

        expect(user1.email, equals(user2.email));
        expect(user2.email, equals(user3.email));
        expect(user1.id, equals(user2.id));
        expect(user2.id, equals(user3.id));
      });
    });
  });
}
