import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/cognito/lib/ds_cognito_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

/// Mock Cognito Auth Provider for testing without real AWS setup
class MockCognitoAuthProvider implements DSAuthProvider {
  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _credentials = {};
  final Map<String, String> _refreshTokens = {};
  final Map<String, String> _confirmationCodes = {};

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
    print('Mock Cognito Auth Provider initialized');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_credentials[username] == password) {
      _currentUser = _users[username];
      print('Mock Cognito sign in successful for: $username');
    } else {
      throw DSAuthError('Invalid credentials');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    print('Mock Cognito sign out successful');
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
      id: 'cognito|${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'Cognito User',
      customAttributes: {
        'provider': 'cognito',
        'email_verified': false,
        'user_pool_id': 'us-east-1_test12345',
        'given_name': displayName?.split(' ').first,
        'family_name': displayName?.split(' ').last,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    
    _users[email] = user;
    _credentials[email] = password;
    _refreshTokens[email] = 'cognito_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
    _confirmationCodes[email] = '123456';
    print('Mock Cognito account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (token == null) return _currentUser != null;
    
    // Mock JWT token validation
    if (token.startsWith('cognito_') && token.contains('_token_') && _currentUser != null) {
      return true;
    }
    
    // Mock JWT format check
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
    if (refreshToken.startsWith('cognito_refresh_token_')) {
      return 'cognito_access_token_${DateTime.now().millisecondsSinceEpoch}';
    }
    
    throw DSAuthError('Invalid refresh token');
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Cognito login success hook called for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('Cognito logout hook called');
  }

  // Additional Cognito-specific methods
  Future<void> sendPasswordResetEmail(String email) async {
    if (!_users.containsKey(email)) {
      throw DSAuthError('User not found');
    }
    print('Mock password reset email sent to: $email');
  }

  Future<void> confirmEmail(String email, String confirmationCode) async {
    if (!_users.containsKey(email)) {
      throw DSAuthError('User not found');
    }
    if (_confirmationCodes[email] != confirmationCode) {
      throw DSAuthError('Invalid confirmation code');
    }
    
    // Update user as confirmed
    final user = _users[email]!;
    final updatedUser = DSAuthUser(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      customAttributes: {
        ...user.customAttributes ?? {},
        'email_verified': true,
      },
    );
    _users[email] = updatedUser;
    print('Mock email confirmed for: $email');
  }

  Future<void> updatePassword(String newPassword) async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in');
    }
    _credentials[_currentUser!.email] = newPassword;
    print('Mock password updated');
  }

  Future<void> updateUserAttributes(Map<String, String> attributes) async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in');
    }
    print('Mock user attributes updated: $attributes');
  }

  Future<void> deleteUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in');
    }
    
    final email = _currentUser!.email;
    _users.remove(email);
    _credentials.remove(email);
    _refreshTokens.remove(email);
    _confirmationCodes.remove(email);
    _currentUser = null;
    print('Mock user deleted');
  }
}

void main() {
  group('Enhanced Cognito Auth Provider Tests', () {
    late MockCognitoAuthProvider mockProvider;
    late DSAuthManager authManager;

    setUp(() async {
      mockProvider = MockCognitoAuthProvider();
      
      // Initialize the provider
      await mockProvider.initialize({
        'userPoolId': 'us-east-1_test12345',
        'clientId': 'test_client_id',
        'region': 'us-east-1',
        'clientSecret': 'test_client_secret',
      });
      
      // Register with auth manager
      DSAuthManager.registerProvider(
        'cognito',
        mockProvider,
        DSAuthProviderMetadata(
          type: 'Cognito',
          region: 'us-east-1',
          clientId: 'test_client_id',
        ),
      );
      authManager = DSAuthManager('cognito');
    });

    tearDown(() {
      // Clean up between tests
      DSAuthManager.enableDebugging = false;
      DSAuthManager.clearProviders();
    });

    group('Authentication Flow Tests', () {
      test('Complete Cognito Authentication Flow', () async {
        // Enable debugging for detailed logs
        DSAuthManager.enableDebugging = true;
        
        // 1. Create a new account
        await authManager.createAccount(
          'test@example.com', 
          'TempPassword123!',
          displayName: 'Test User',
        );

        // 2. Confirm email (Cognito-specific step)
        await mockProvider.confirmEmail('test@example.com', '123456');

        // 3. Sign in with the created account
        await authManager.signIn('test@example.com', 'TempPassword123!');

        // 4. Get current user
        final currentUser = await authManager.getCurrentUser();
        expect(currentUser.email, equals('test@example.com'));
        expect(currentUser.displayName, equals('Test User'));
        expect(currentUser.id, startsWith('cognito|'));
        expect(currentUser.customAttributes?['provider'], equals('cognito'));
        expect(currentUser.customAttributes?['email_verified'], isTrue);

        // 5. Verify token
        final isValidToken = await authManager.verifyToken('cognito_access_token_123456');
        expect(isValidToken, isTrue);

        // 6. Refresh token
        final newToken = await authManager.refreshToken('cognito_refresh_token_123456');
        expect(newToken, startsWith('cognito_access_token_'));

        // 7. Sign out
        await authManager.signOut();

        // 8. Verify sign out worked
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Cognito Token Validation', () async {
        await authManager.createAccount('token@test.com', 'Password123!');
        await authManager.signIn('token@test.com', 'Password123!');
        
        // Valid Cognito token
        final validToken = await authManager.verifyToken('cognito_access_token_123456');
        expect(validToken, isTrue);
        
        // Valid JWT format
        final validJWT = await authManager.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.payload.signature');
        expect(validJWT, isTrue);
        
        // Invalid token format
        final invalidToken = await authManager.verifyToken('invalid_token');
        expect(invalidToken, isFalse);
        
        // Empty token
        final emptyToken = await authManager.verifyToken('');
        expect(emptyToken, isFalse);
      });

      test('Cognito User Attributes', () async {
        await authManager.createAccount(
          'attributes@test.com',
          'Password123!',
          displayName: 'Attributes User',
        );
        
        final user = await authManager.getUser('cognito|attributes_test_com');
        expect(user.customAttributes?['provider'], equals('cognito'));
        expect(user.customAttributes?['user_pool_id'], equals('us-east-1_test12345'));
        expect(user.customAttributes?['created_at'], isNotNull);
        expect(user.customAttributes?['given_name'], equals('Attributes'));
        expect(user.customAttributes?['family_name'], equals('User'));
      });

      test('Invalid Credentials Test', () async {
        await authManager.createAccount('user@test.com', 'CorrectPass123!');
        
        expect(
          () => authManager.signIn('user@test.com', 'WrongPass123!'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Duplicate Account Creation', () async {
        await authManager.createAccount('duplicate@test.com', 'Pass123!');
        
        expect(
          () => authManager.createAccount('duplicate@test.com', 'Pass456!'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Provider Management Tests', () {
      test('Provider Registration and Retrieval', () {
        // Test that provider was registered correctly
        expect(authManager, isNotNull);
        
        // Test metadata
        final metadata = authManager.getProviderMetadata('cognito');
        expect(metadata, isNotNull);
        expect(metadata!.type, equals('Cognito'));
        expect(metadata.region, equals('us-east-1'));
        expect(metadata.clientId, equals('test_client_id'));
        print('Cognito Provider metadata: ${metadata.type}, ${metadata.region}, ${metadata.clientId}');
      });

      test('Unregistered Provider Error', () {
        expect(
          () => DSAuthManager('nonexistent'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Cognito-Specific Features', () {
      test('Email Confirmation Flow', () async {
        // Create account
        await authManager.createAccount('confirm@test.com', 'Pass123!');
        
        // Initially email should not be verified
        final userBeforeConfirm = await authManager.getUser('cognito|confirm_test_com');
        expect(userBeforeConfirm.customAttributes?['email_verified'], isFalse);
        
        // Confirm email
        await mockProvider.confirmEmail('confirm@test.com', '123456');
        
        // Now email should be verified
        final userAfterConfirm = await authManager.getUser('cognito|confirm_test_com');
        expect(userAfterConfirm.customAttributes?['email_verified'], isTrue);
      });

      test('Password Reset Flow', () async {
        await authManager.createAccount('reset@test.com', 'OldPass123!');
        
        // Send password reset email
        await mockProvider.sendPasswordResetEmail('reset@test.com');
        
        // This should not throw
        expect(true, isTrue);
      });

      test('User Attribute Updates', () async {
        await authManager.createAccount('update@test.com', 'Pass123!');
        await authManager.signIn('update@test.com', 'Pass123!');
        
        // Update user attributes
        await mockProvider.updateUserAttributes({
          'given_name': 'Updated',
          'family_name': 'Name',
          'phone_number': '+1234567890',
        });
        
        // This should not throw
        expect(true, isTrue);
      });

      test('Password Update', () async {
        await authManager.createAccount('passupdate@test.com', 'OldPass123!');
        await authManager.signIn('passupdate@test.com', 'OldPass123!');
        
        // Update password
        await mockProvider.updatePassword('NewPass123!');
        
        // Sign out and sign in with new password
        await authManager.signOut();
        await authManager.signIn('passupdate@test.com', 'NewPass123!');
        
        // Should be successful
        final user = await authManager.getCurrentUser();
        expect(user.email, equals('passupdate@test.com'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Operations Without Initialization', () async {
        final uninitializedProvider = MockCognitoAuthProvider();
        
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
        await authManager.createAccount('tokentest@example.com', 'Pass123!');
        await authManager.signIn('tokentest@example.com', 'Pass123!');
        
        expect(
          () => authManager.refreshToken('invalid_refresh_token'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Invalid Confirmation Code', () async {
        await authManager.createAccount('confirm@test.com', 'Pass123!');
        
        expect(
          () => mockProvider.confirmEmail('confirm@test.com', '000000'),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('Password Reset for Non-existent User', () async {
        expect(
          () => mockProvider.sendPasswordResetEmail('nonexistent@test.com'),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('Security Tests', () {
      test('Token Validation Edge Cases', () async {
        await authManager.createAccount('security@test.com', 'Pass123!');
        await authManager.signIn('security@test.com', 'Pass123!');
        
        // Valid Cognito token
        final validToken = await authManager.verifyToken('cognito_access_token_123456');
        expect(validToken, isTrue);
        
        // Invalid token format
        final invalidToken = await mockProvider.verifyToken('invalid_format');
        expect(invalidToken, isFalse);
        
        // Null token when signed in
        final nullToken = await authManager.verifyToken(null);
        expect(nullToken, isTrue);
      });

      test('User ID Format Validation', () async {
        await authManager.createAccount('format@test.com', 'Pass123!');
        
        final user = await authManager.getUser('cognito|format_test_com');
        expect(user.id, startsWith('cognito|'));
        expect(user.id, contains('format_test_com'));
      });
    });

    group('Lifecycle Hook Tests', () {
      test('Login Success Hook', () async {
        await authManager.createAccount('hooks@test.com', 'Pass123!');
        
        // This should trigger the onLoginSuccess hook
        await authManager.signIn('hooks@test.com', 'Pass123!');
        
        final user = await authManager.getCurrentUser();
        await mockProvider.onLoginSuccess(user);
        
        // Hook should log success message
        expect(user.email, equals('hooks@test.com'));
      });

      test('Logout Hook', () async {
        await authManager.createAccount('logout@test.com', 'Pass123!');
        await authManager.signIn('logout@test.com', 'Pass123!');
        
        await authManager.signOut();
        await mockProvider.onLogout();
        
        // Hook should log logout message
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });
    });

    group('User Management Tests', () {
      test('User Deletion', () async {
        await authManager.createAccount('delete@test.com', 'Pass123!');
        await authManager.signIn('delete@test.com', 'Pass123!');
        
        // Delete user
        await mockProvider.deleteUser();
        
        // User should be deleted
        expect(
          () => authManager.getCurrentUser(),
          throwsA(isA<DSAuthError>()),
        );
      });

      test('User Attribute Management', () async {
        await authManager.createAccount('attrs@test.com', 'Pass123!', displayName: 'Attr User');
        
        final user = await authManager.getUser('cognito|attrs_test_com');
        expect(user.customAttributes?['given_name'], equals('Attr'));
        expect(user.customAttributes?['family_name'], equals('User'));
        expect(user.customAttributes?['provider'], equals('cognito'));
        expect(user.customAttributes?['user_pool_id'], equals('us-east-1_test12345'));
      });
    });
  });

  group('Cognito Auth Provider Integration Tests', () {
    test('Real Cognito Provider Initialization', () {
      // Test the actual DSCognitoAuthProvider class
      final cognitoProvider = DSCognitoAuthProvider(
        userPoolId: 'us-east-1_test12345',
        clientId: 'test_client_id',
        region: 'us-east-1',
        clientSecret: 'test_client_secret',
        identityPoolId: 'us-east-1:test-identity-pool-id',
      );

      expect(cognitoProvider.userPoolId, equals('us-east-1_test12345'));
      expect(cognitoProvider.clientId, equals('test_client_id'));
      expect(cognitoProvider.region, equals('us-east-1'));
      expect(cognitoProvider.clientSecret, equals('test_client_secret'));
      expect(cognitoProvider.identityPoolId, equals('us-east-1:test-identity-pool-id'));
    });

    test('Factory Pattern Singleton', () {
      final provider1 = DSCognitoAuthProvider(
        userPoolId: 'us-east-1_pool1',
        clientId: 'client1',
        region: 'us-east-1',
      );
      
      final provider2 = DSCognitoAuthProvider(
        userPoolId: 'us-east-1_pool2',
        clientId: 'client2',
        region: 'us-west-2',
      );

      // Should return the same instance due to singleton pattern
      expect(identical(provider1, provider2), isTrue);
    });

    test('Cognito Configuration Validation', () {
      final provider = DSCognitoAuthProvider(
        userPoolId: 'us-east-1_abcdef123456',
        clientId: 'client_id_123',
        region: 'us-east-1',
        clientSecret: 'client_secret_456',
      );

      expect(provider.userPoolId, contains('us-east-1_'));
      expect(provider.region, equals('us-east-1'));
      expect(provider.clientId, isNotEmpty);
      expect(provider.clientSecret, isNotEmpty);
    });
  });
}
