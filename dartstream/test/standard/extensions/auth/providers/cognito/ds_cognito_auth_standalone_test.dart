import 'package:test/test.dart';

// Mock implementations for Cognito testing - these would normally come from ds_auth_base package

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

/// Cognito Provider Manager
class DSAuthManager {
  static final Map<String, DSAuthProvider> _registeredProviders = {};
  static final Map<String, DSAuthProviderMetadata> _providerMetadata = {};
  static bool enableDebugging = false;

  final String _providerName;
  late final DSAuthProvider _provider;

  DSAuthManager(this._providerName) {
    if (!_registeredProviders.containsKey(_providerName)) {
      throw DSAuthError('Provider $_providerName not registered');
    }
    _provider = _registeredProviders[_providerName]!;
  }

  static void registerProvider(String name, DSAuthProvider provider, [DSAuthProviderMetadata? metadata]) {
    _registeredProviders[name] = provider;
    if (metadata != null) {
      _providerMetadata[name] = metadata;
    }
    if (enableDebugging) {
      print('DSAuthManager: Registered provider: $name');
    }
  }

  static void clearProviders() {
    _registeredProviders.clear();
    _providerMetadata.clear();
  }

  DSAuthProviderMetadata? getProviderMetadata(String providerName) {
    return _providerMetadata[providerName];
  }

  Future<void> createAccount(String email, String password, {String? displayName}) async {
    if (enableDebugging) print('DSAuthManager: Creating new account...');
    await _provider.createAccount(email, password, displayName: displayName);
  }

  Future<void> signIn(String username, String password) async {
    if (enableDebugging) print('DSAuthManager: Signing in with provider...');
    await _provider.signIn(username, password);
  }

  Future<void> signOut() async {
    if (enableDebugging) print('DSAuthManager: Signing out with provider...');
    await _provider.signOut();
  }

  Future<DSAuthUser> getCurrentUser() async {
    if (enableDebugging) print('DSAuthManager: Fetching current user...');
    return await _provider.getCurrentUser();
  }

  Future<DSAuthUser> getUser(String userId) async {
    if (enableDebugging) print('DSAuthManager: Fetching user by ID...');
    return await _provider.getUser(userId);
  }

  Future<bool> verifyToken([String? token]) async {
    if (enableDebugging) print('DSAuthManager: Verifying token...');
    return await _provider.verifyToken(token);
  }

  Future<String> refreshToken(String refreshToken) async {
    if (enableDebugging) print('DSAuthManager: Refreshing token...');
    return await _provider.refreshToken(refreshToken);
  }
}

/// Provider metadata
class DSAuthProviderMetadata {
  final String type;
  final String region;
  final String clientId;

  DSAuthProviderMetadata({
    required this.type,
    required this.region,
    required this.clientId,
  });
}

/// Full Cognito Provider Implementation for standalone testing
class StandaloneCognitoAuthProvider implements DSAuthProvider {
  final String userPoolId;
  final String clientId;
  final String region;
  final String? clientSecret;
  final String? identityPoolId;

  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  String? _idToken;

  // Mock storage
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _credentials = {};
  final Map<String, String> _refreshTokens = {};
  final Map<String, bool> _emailVerifications = {};
  final Map<String, String> _confirmationCodes = {};

  StandaloneCognitoAuthProvider({
    required this.userPoolId,
    required this.clientId,
    required this.region,
    this.clientSecret,
    this.identityPoolId,
  });

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) return;
    
    // Mock initialization
    await Future.delayed(Duration(milliseconds: 100));
    _isInitialized = true;
    print('Standalone Cognito Provider initialized');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw DSAuthError('Provider not initialized');
    
    if (!_credentials.containsKey(username) || _credentials[username] != password) {
      throw DSAuthError('Invalid credentials');
    }

    if (_emailVerifications[username] != true) {
      throw DSAuthError('Email not verified');
    }

    _currentUser = _users[username];
    _accessToken = 'cognito_access_${DateTime.now().millisecondsSinceEpoch}';
    _refreshToken = _refreshTokens[username];
    _idToken = 'cognito_id_${DateTime.now().millisecondsSinceEpoch}';

    await onLoginSuccess(_currentUser!);
    print('Standalone Cognito sign-in successful for: $username');
  }

  @override
  Future<void> signOut() async {
    if (_currentUser != null) {
      await onLogout();
      _currentUser = null;
      _accessToken = null;
      _refreshToken = null;
      _idToken = null;
      print('Standalone Cognito sign-out successful');
    }
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError('User not found'),
    );
    return user;
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user currently signed in');
    }
    return _currentUser!;
  }

  @override
  Future<void> createAccount(String email, String password, {String? displayName}) async {
    if (!_isInitialized) throw DSAuthError('Provider not initialized');
    
    if (_users.containsKey(email)) {
      throw DSAuthError('User already exists');
    }

    final user = DSAuthUser(
      id: 'cognito_${userPoolId}_${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'Cognito User',
      customAttributes: {
        'provider': 'cognito',
        'user_pool_id': userPoolId,
        'region': region,
        'email_verified': false,
        'phone_number_verified': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    );

    _users[email] = user;
    _credentials[email] = password;
    _refreshTokens[email] = 'cognito_refresh_${DateTime.now().millisecondsSinceEpoch}';
    _emailVerifications[email] = false;
    _confirmationCodes[email] = '${100000 + DateTime.now().millisecond % 900000}'; // 6-digit code

    print('Standalone Cognito account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (token == null) return _currentUser != null;
    
    // Mock JWT validation
    if (token.startsWith('cognito_') || (token.startsWith('eyJ') && token.split('.').length == 3)) {
      return _currentUser != null;
    }
    return false;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (_currentUser == null) throw DSAuthError('No user signed in');
    
    if (!refreshToken.startsWith('cognito_refresh_')) {
      throw DSAuthError('Invalid refresh token');
    }

    _accessToken = 'cognito_access_${DateTime.now().millisecondsSinceEpoch}';
    return _accessToken!;
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Standalone Cognito login success for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('Standalone Cognito logout');
  }

  // Cognito-specific methods
  Future<void> confirmEmail(String email, String confirmationCode) async {
    if (!_users.containsKey(email)) {
      throw DSAuthError('User not found');
    }

    if (_confirmationCodes[email] != confirmationCode) {
      throw DSAuthError('Invalid confirmation code');
    }

    _emailVerifications[email] = true;
    
    // Update user attributes
    final user = _users[email]!;
    final updatedUser = DSAuthUser(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      customAttributes: {
        ...user.customAttributes ?? {},
        'email_verified': true,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
    _users[email] = updatedUser;

    print('Standalone Cognito email confirmed for: $email');
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!_users.containsKey(email)) {
      throw DSAuthError('User not found');
    }
    print('Standalone Cognito password reset email sent to: $email');
  }

  Future<void> updatePassword(String newPassword) async {
    if (_currentUser == null) throw DSAuthError('No user signed in');
    _credentials[_currentUser!.email] = newPassword;
    print('Standalone Cognito password updated');
  }

  Future<void> updateUserAttributes(Map<String, String> attributes) async {
    if (_currentUser == null) throw DSAuthError('No user signed in');
    
    final user = _currentUser!;
    final updatedAttributes = {...user.customAttributes ?? {}, ...attributes};
    updatedAttributes['updated_at'] = DateTime.now().toIso8601String();
    
    final updatedUser = DSAuthUser(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      customAttributes: updatedAttributes,
    );
    
    _users[user.email] = updatedUser;
    _currentUser = updatedUser;
    print('Standalone Cognito user attributes updated');
  }

  Future<void> deleteUser() async {
    if (_currentUser == null) throw DSAuthError('No user signed in');
    
    final email = _currentUser!.email;
    _users.remove(email);
    _credentials.remove(email);
    _refreshTokens.remove(email);
    _emailVerifications.remove(email);
    _confirmationCodes.remove(email);
    
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    _idToken = null;
    
    print('Standalone Cognito user deleted');
  }
}

void main() {
  group('Standalone Cognito Auth Provider Tests', () {
    late StandaloneCognitoAuthProvider provider;
    late DSAuthManager authManager;

    setUp(() async {
      provider = StandaloneCognitoAuthProvider(
        userPoolId: 'us-east-1_standalone123',
        clientId: 'standalone_client_id',
        region: 'us-east-1',
        clientSecret: 'standalone_client_secret',
        identityPoolId: 'us-east-1:standalone-identity-pool',
      );

      await provider.initialize({});

      DSAuthManager.registerProvider(
        'cognito',
        provider,
        DSAuthProviderMetadata(
          type: 'Cognito',
          region: 'us-east-1',
          clientId: 'standalone_client_id',
        ),
      );

      authManager = DSAuthManager('cognito');
    });

    tearDown(() {
      DSAuthManager.clearProviders();
    });

    test('Full Cognito Workflow', () async {
      // Create account
      await authManager.createAccount(
        'workflow@example.com',
        'Password123!',
        displayName: 'Workflow User',
      );

      // Confirm email
      await provider.confirmEmail('workflow@example.com', provider._confirmationCodes['workflow@example.com']!);

      // Sign in
      await authManager.signIn('workflow@example.com', 'Password123!');

      // Get user
      final user = await authManager.getCurrentUser();
      expect(user.email, equals('workflow@example.com'));
      expect(user.customAttributes?['email_verified'], isTrue);

      // Verify token
      final isValidToken = await authManager.verifyToken();
      expect(isValidToken, isTrue);

      // Update attributes
      await provider.updateUserAttributes({
        'given_name': 'Updated',
        'family_name': 'User',
      });

      // Refresh token
      final newToken = await authManager.refreshToken(provider._refreshToken!);
      expect(newToken, startsWith('cognito_access_'));

      // Sign out
      await authManager.signOut();
    });

    test('Email Confirmation Workflow', () async {
      await authManager.createAccount('confirm@example.com', 'Password123!');
      
      // Get confirmation code
      final confirmationCode = provider._confirmationCodes['confirm@example.com']!;
      
      // Confirm email
      await provider.confirmEmail('confirm@example.com', confirmationCode);
      
      // Sign in should now work
      await authManager.signIn('confirm@example.com', 'Password123!');
      
      final user = await authManager.getCurrentUser();
      expect(user.customAttributes?['email_verified'], isTrue);
    });

    test('Password Reset Workflow', () async {
      await authManager.createAccount('reset@example.com', 'OldPassword123!');
      await provider.confirmEmail('reset@example.com', provider._confirmationCodes['reset@example.com']!);
      
      // Send password reset
      await provider.sendPasswordResetEmail('reset@example.com');
      
      // Sign in
      await authManager.signIn('reset@example.com', 'OldPassword123!');
      
      // Update password
      await provider.updatePassword('NewPassword123!');
      
      // Sign out and sign in with new password
      await authManager.signOut();
      await authManager.signIn('reset@example.com', 'NewPassword123!');
      
      final user = await authManager.getCurrentUser();
      expect(user.email, equals('reset@example.com'));
    });

    test('User Management', () async {
      await authManager.createAccount('manage@example.com', 'Password123!', displayName: 'Manage User');
      await provider.confirmEmail('manage@example.com', provider._confirmationCodes['manage@example.com']!);
      await authManager.signIn('manage@example.com', 'Password123!');
      
      // Update attributes
      await provider.updateUserAttributes({
        'given_name': 'Updated',
        'family_name': 'Manager',
        'phone_number': '+1234567890',
      });
      
      final user = await authManager.getCurrentUser();
      expect(user.customAttributes?['given_name'], equals('Updated'));
      expect(user.customAttributes?['family_name'], equals('Manager'));
      expect(user.customAttributes?['phone_number'], equals('+1234567890'));
    });

    test('Error Handling', () async {
      // Try to sign in without creating account
      expect(
        () => authManager.signIn('nonexistent@example.com', 'password'),
        throwsA(isA<DSAuthError>()),
      );
      
      // Create account and try to sign in without email confirmation
      await authManager.createAccount('unconfirmed@example.com', 'Password123!');
      expect(
        () => authManager.signIn('unconfirmed@example.com', 'Password123!'),
        throwsA(isA<DSAuthError>()),
      );
      
      // Try invalid confirmation code
      expect(
        () => provider.confirmEmail('unconfirmed@example.com', '000000'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('Token Management', () async {
      await authManager.createAccount('token@example.com', 'Password123!');
      await provider.confirmEmail('token@example.com', provider._confirmationCodes['token@example.com']!);
      await authManager.signIn('token@example.com', 'Password123!');
      
      // Test various token formats
      expect(await authManager.verifyToken('cognito_access_123456'), isTrue);
      expect(await authManager.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.payload.signature'), isTrue);
      expect(await authManager.verifyToken('invalid_token'), isFalse);
      expect(await authManager.verifyToken(), isTrue); // Current user token
    });

    test('User Deletion', () async {
      await authManager.createAccount('delete@example.com', 'Password123!');
      await provider.confirmEmail('delete@example.com', provider._confirmationCodes['delete@example.com']!);
      await authManager.signIn('delete@example.com', 'Password123!');
      
      // Delete user
      await provider.deleteUser();
      
      // Should no longer be signed in
      expect(
        () => authManager.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('Provider Configuration', () {
      expect(provider.userPoolId, equals('us-east-1_standalone123'));
      expect(provider.clientId, equals('standalone_client_id'));
      expect(provider.region, equals('us-east-1'));
      expect(provider.clientSecret, equals('standalone_client_secret'));
      expect(provider.identityPoolId, equals('us-east-1:standalone-identity-pool'));
    });
  });
}
