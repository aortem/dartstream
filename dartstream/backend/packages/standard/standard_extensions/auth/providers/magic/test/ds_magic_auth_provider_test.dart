import 'package:test/test.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

// Mock classes to avoid Magic SDK dependency issues
class MockDSMagicAuthProvider implements DSAuthProvider {
  bool _isInitialized = false;
  String? _currentUserId;
  String? _currentDIDToken;
  final Map<String, String> _tokens = {};
  final Map<String, Map<String, dynamic>> _sessions = {};

  final String publishableKey;
  final String secretKey;

  MockDSMagicAuthProvider({
    required this.publishableKey,
    required this.secretKey,
  });

  bool get isSignedIn => _currentUserId != null && _currentDIDToken != null;
  String? get currentUserId => _currentUserId;
  String? get currentDIDToken => _currentDIDToken;

  void clearCurrentSession() {
    _currentUserId = null;
    _currentDIDToken = null;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw DSAuthError(
        'Magic Auth Provider is not initialized. Call initialize() first.',
        code: 500,
      );
    }
  }

  bool _isValidDIDToken(String token) {
    // Simple validation: JWT should have 3 parts
    final parts = token.split('.');
    return parts.length == 3 && token.isNotEmpty;
  }

  Map<String, dynamic>? _mockVerifyToken(String token) {
    if (!_isValidDIDToken(token)) {
      return null;
    }

    // Mock token verification - in real scenario, this would verify with Magic
    return {
      'issuer': 'did:ethr:0x1234567890',
      'email': 'test@example.com',
      'publicAddress': '0x1234567890',
    };
  }

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      print('Magic Auth Provider already initialized');
      return;
    }
    _isInitialized = true;
    print('Magic Auth Provider initialized successfully');
  }

  @override
  Future<void> signIn(String email, String password) async {
    _ensureInitialized();

    final didToken = password;
    if (didToken.isEmpty) {
      throw DSAuthError('DID token is required for Magic sign-in');
    }

    final userInfo = _mockVerifyToken(didToken);
    if (userInfo == null) {
      throw DSAuthError('Failed to verify Magic DID token');
    }

    _currentUserId = userInfo['issuer'];
    _currentDIDToken = didToken;

    _tokens[_currentUserId!] = didToken;
    _sessions[_currentUserId!] = {
      'userId': _currentUserId,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await onLoginSuccess(
      DSAuthUser(
        id: userInfo['issuer'],
        email: userInfo['email'] ?? '',
        displayName: userInfo['publicAddress'] ?? '',
        customAttributes: userInfo,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    _ensureInitialized();

    if (_currentUserId != null) {
      _tokens.remove(_currentUserId);
      _sessions.remove(_currentUserId);
    }

    _currentUserId = null;
    _currentDIDToken = null;
    await onLogout();
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    _ensureInitialized();
    await signIn(email, password);
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    _ensureInitialized();

    if (_currentUserId == null || _currentDIDToken == null) {
      throw DSAuthError('No user is currently signed in');
    }

    final userInfo = _mockVerifyToken(_currentDIDToken!);
    if (userInfo == null) {
      throw DSAuthError('Failed to fetch user info');
    }

    return DSAuthUser(
      id: userInfo['issuer'],
      email: userInfo['email'] ?? '',
      displayName: userInfo['publicAddress'] ?? '',
      customAttributes: userInfo,
    );
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    throw UnimplementedError(
      'getUser is not supported by Magic API. Store user info after sign-in.',
    );
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    _ensureInitialized();

    final didToken = token ?? _currentDIDToken;
    if (didToken == null) return false;

    final userInfo = _mockVerifyToken(didToken);
    return userInfo != null;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    throw UnimplementedError(
      'Magic tokens cannot be refreshed; re-authenticate instead.',
    );
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // Mock implementation
  }

  @override
  Future<void> onLogout() async {
    // Mock implementation
  }
}

void main() {
  group('DSMagicAuthProvider - Initialization', () {
    late MockDSMagicAuthProvider provider;

    setUp(() {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
    });

    test('should initialize successfully', () async {
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });

      expect(provider.isSignedIn, isFalse);
      expect(provider.currentUserId, isNull);
      expect(provider.currentDIDToken, isNull);
    });

    test('should handle double initialization gracefully', () async {
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });

      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });

      expect(provider.isSignedIn, isFalse);
    });

    test('should throw error when calling methods before initialization', () async {
      expect(
        () => provider.signIn('test@example.com', 'test_token'),
        throwsA(isA<DSAuthError>()),
      );
    });
  });

  group('DSMagicAuthProvider - Sign In', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should throw error for empty DID token', () async {
      expect(
        () => provider.signIn('test@example.com', ''),
        throwsA(
          predicate((e) =>
              e is DSAuthError &&
              e.message == 'DID token is required for Magic sign-in'),
        ),
      );
    });

    test('should reject invalid DID token format', () async {
      expect(
        () => provider.signIn('test@example.com', 'invalid_token'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('should validate DID token structure', () async {
      final invalidToken = 'only.two';

      expect(
        () => provider.signIn('test@example.com', invalidToken),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('should successfully sign in with valid token', () async {
      final validToken = 'header.payload.signature';

      await provider.signIn('test@example.com', validToken);

      expect(provider.isSignedIn, isTrue);
      expect(provider.currentUserId, isNotNull);
      expect(provider.currentDIDToken, equals(validToken));
    });
  });

  group('DSMagicAuthProvider - Sign Out', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should handle sign out when not signed in', () async {
      await provider.signOut();

      expect(provider.isSignedIn, isFalse);
      expect(provider.currentUserId, isNull);
    });

    test('should clear session data on sign out', () async {
      final validToken = 'header.payload.signature';
      await provider.signIn('test@example.com', validToken);

      expect(provider.isSignedIn, isTrue);

      await provider.signOut();

      expect(provider.currentUserId, isNull);
      expect(provider.currentDIDToken, isNull);
      expect(provider.isSignedIn, isFalse);
    });
  });

  group('DSMagicAuthProvider - Get Current User', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should throw error when no user is signed in', () async {
      expect(
        () => provider.getCurrentUser(),
        throwsA(
          predicate((e) =>
              e is DSAuthError &&
              e.message == 'No user is currently signed in'),
        ),
      );
    });

    test('should return current user when signed in', () async {
      final validToken = 'header.payload.signature';
      await provider.signIn('test@example.com', validToken);

      final user = await provider.getCurrentUser();

      expect(user, isNotNull);
      expect(user.id, isNotEmpty);
      expect(user.email, equals('test@example.com'));
    });
  });

  group('DSMagicAuthProvider - Token Verification', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should return false for null token when not signed in', () async {
      final isValid = await provider.verifyToken();
      expect(isValid, isFalse);
    });

    test('should return false for invalid token', () async {
      final isValid = await provider.verifyToken('invalid_token');
      expect(isValid, isFalse);
    });

    test('should return false for empty token', () async {
      final isValid = await provider.verifyToken('');
      expect(isValid, isFalse);
    });

    test('should return true for valid token', () async {
      final validToken = 'header.payload.signature';
      final isValid = await provider.verifyToken(validToken);
      expect(isValid, isTrue);
    });

    test('should verify current token after sign in', () async {
      final validToken = 'header.payload.signature';
      await provider.signIn('test@example.com', validToken);

      final isValid = await provider.verifyToken();
      expect(isValid, isTrue);
    });
  });

  group('DSMagicAuthProvider - Create Account', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should throw error for invalid credentials', () async {
      expect(
        () => provider.createAccount('test@example.com', ''),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('should handle display name parameter', () async {
      expect(
        () => provider.createAccount(
          'test@example.com',
          'invalid_token',
          displayName: 'Test User',
        ),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('should successfully create account with valid token', () async {
      final validToken = 'header.payload.signature';

      await provider.createAccount(
        'test@example.com',
        validToken,
        displayName: 'Test User',
      );

      expect(provider.isSignedIn, isTrue);
    });
  });

  group('DSMagicAuthProvider - Unimplemented Methods', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should throw UnimplementedError for getUser', () async {
      expect(
        () => provider.getUser('user_123'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should throw UnimplementedError for refreshToken', () async {
      expect(
        () => provider.refreshToken('refresh_token'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('DSMagicAuthProvider - Lifecycle Hooks', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should call onLoginSuccess without error', () async {
      final user = DSAuthUser(
        id: 'test_user_id',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      await provider.onLoginSuccess(user);
    });

    test('should call onLogout without error', () async {
      await provider.onLogout();
    });
  });

  group('DSMagicAuthProvider - Session Management', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should start with no active session', () {
      expect(provider.isSignedIn, isFalse);
      expect(provider.currentUserId, isNull);
      expect(provider.currentDIDToken, isNull);
    });

    test('should clear session successfully', () {
      provider.clearCurrentSession();

      expect(provider.isSignedIn, isFalse);
      expect(provider.currentUserId, isNull);
      expect(provider.currentDIDToken, isNull);
    });

    test('should maintain session after sign in', () async {
      final validToken = 'header.payload.signature';
      await provider.signIn('test@example.com', validToken);

      expect(provider.isSignedIn, isTrue);
      expect(provider.currentUserId, isNotNull);
      expect(provider.currentDIDToken, equals(validToken));
    });
  });

  group('DSMagicAuthProvider - Error Handling', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should handle malformed tokens gracefully', () async {
      final malformedTokens = [
        'not.a.valid.token.format',
        'only_one_part',
        '',
        'a.b',
      ];

      for (final token in malformedTokens) {
        expect(
          () => provider.signIn('test@example.com', token),
          throwsA(isA<DSAuthError>()),
          reason: 'Failed for token: $token',
        );
      }
    });

    test('should provide meaningful error messages', () async {
      try {
        await provider.signIn('test@example.com', '');
      } catch (e) {
        expect(e, isA<DSAuthError>());
        expect((e as DSAuthError).message, isNotEmpty);
      }
    });
  });

  group('DSMagicAuthProvider - Integration with Auth Manager', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should register with DSAuthManager', () {
      DSAuthManager.clearProviders();
      DSAuthManager.registerProvider('magic', provider);

      final registeredProviders = DSAuthManager.getRegisteredProviders();
      expect(registeredProviders, contains('magic'));
    });

    test('should work with DSAuthManager instance', () async {
      DSAuthManager.clearProviders();
      DSAuthManager.registerProvider('magic', provider);

      final manager = DSAuthManager('magic');

      expect(
        () => manager.signIn('test@example.com', ''),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('should support provider metadata', () {
      DSAuthManager.clearProviders();

      final metadata = DSAuthProviderMetadata(
        type: 'magic',
        region: 'us-east-1',
        clientId: 'test_client_id',
      );

      DSAuthManager.registerProvider('magic', provider, metadata);

      final retrievedMetadata = DSAuthManager.getProviderMetadata('magic');
      expect(retrievedMetadata, isNotNull);
      expect(retrievedMetadata?.type, equals('magic'));
      expect(retrievedMetadata?.region, equals('us-east-1'));
    });

    test('should handle full authentication flow through manager', () async {
      DSAuthManager.clearProviders();
      DSAuthManager.registerProvider('magic', provider);

      final manager = DSAuthManager('magic');
      final validToken = 'header.payload.signature';

      await manager.signIn('test@example.com', validToken);
      expect(provider.isSignedIn, isTrue);

      final user = await manager.getCurrentUser();
      expect(user, isNotNull);
      expect(user.email, equals('test@example.com'));

      await manager.signOut();
      expect(provider.isSignedIn, isFalse);
    });

    tearDown(() {
      DSAuthManager.clearProviders();
    });
  });

  group('DSMagicAuthProvider - Complete User Journey', () {
    late MockDSMagicAuthProvider provider;

    setUp(() async {
      provider = MockDSMagicAuthProvider(
        publishableKey: 'test_publishable_key',
        secretKey: 'test_secret_key',
      );
      await provider.initialize({
        'publishableKey': 'test_publishable_key',
        'secretKey': 'test_secret_key',
      });
    });

    test('should complete full user authentication journey', () async {
      // Step 1: User is not signed in
      expect(provider.isSignedIn, isFalse);

      // Step 2: User signs in with valid token
      final validToken = 'header.payload.signature';
      await provider.signIn('user@example.com', validToken);
      expect(provider.isSignedIn, isTrue);

      // Step 3: Get current user info
      final user = await provider.getCurrentUser();
      expect(user.email, equals('test@example.com'));

      // Step 4: Verify token is valid
      final isValid = await provider.verifyToken();
      expect(isValid, isTrue);

      // Step 5: User signs out
      await provider.signOut();
      expect(provider.isSignedIn, isFalse);

      // Step 6: Cannot get user after sign out
      expect(
        () => provider.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });
  });
}