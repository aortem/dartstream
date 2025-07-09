import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/entraid/lib/ds_entraid_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_manager.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

/// Mock EntraID Auth Provider for testing without real EntraID setup
class MockEntraIDAuthProvider implements DSAuthProvider {
  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _credentials = {};
  final Map<String, String> _refreshTokens = {};
  final Map<String, List<String>> _userGroups = {};
  final Map<String, Map<String, dynamic>> _userAttributes = {};

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
    print('Mock EntraID Auth Provider initialized');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) throw Exception('Provider not initialized');
    
    if (_credentials[username] == password) {
      _currentUser = _users[username];
      print('Mock EntraID sign in successful for: $username');
    } else {
      throw DSAuthError('Invalid credentials');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    print('Mock EntraID sign out successful');
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
      id: 'entraid|${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'EntraID User',
      customAttributes: {
        'provider': 'entraid',
        'email_verified': true,
        'created_at': DateTime.now().toIso8601String(),
        'tenant_id': 'test-tenant-id',
        'user_flow': 'B2C_1_signup_signin',
      },
    );
    
    _users[email] = user;
    _credentials[email] = password;
    _refreshTokens[email] = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
    _userGroups[user.id] = ['default_group'];
    _userAttributes[user.id] = {
      'givenName': displayName?.split(' ').first ?? 'Test',
      'surname': displayName?.split(' ').last ?? 'User',
      'country': 'US',
      'city': 'Seattle',
    };
    print('Mock EntraID account created for: $email');
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
    print('EntraID login success hook called for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('EntraID logout hook called');
  }

  // EntraID specific mock methods
  Future<void> resetPassword(String email) async {
    if (!_users.containsKey(email)) {
      throw DSAuthError('User not found');
    }
    print('Mock EntraID password reset initiated for: $email');
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    _userAttributes[userId]!.addAll(updates);
    print('Mock EntraID user profile updated for: $userId');
  }

  Future<void> deleteAccount(String userId) async {
    final userToDelete = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError('User not found'),
    );
    
    _users.remove(userToDelete.email);
    _credentials.remove(userToDelete.email);
    _refreshTokens.remove(userToDelete.email);
    _userGroups.remove(userId);
    _userAttributes.remove(userId);
    print('Mock EntraID account deleted for: $userId');
  }

  Future<Map<String, dynamic>> getUserAttributes(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    return _userAttributes[userId]!;
  }

  Future<void> enableMFA(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    _userAttributes[userId]!['mfa_enabled'] = true;
    print('Mock EntraID MFA enabled for: $userId');
  }

  Future<void> disableMFA(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    _userAttributes[userId]!['mfa_enabled'] = false;
    print('Mock EntraID MFA disabled for: $userId');
  }

  Future<List<String>> getUserGroups(String userId) async {
    if (!_userGroups.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    return _userGroups[userId]!;
  }

  Future<void> assignUserToGroup(String userId, String groupId) async {
    if (!_userGroups.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    if (!_userGroups[userId]!.contains(groupId)) {
      _userGroups[userId]!.add(groupId);
    }
    print('Mock EntraID user $userId assigned to group $groupId');
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    if (!_userGroups.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    _userGroups[userId]!.remove(groupId);
    print('Mock EntraID user $userId removed from group $groupId');
  }

  Future<List<Map<String, dynamic>>> getAuditLogs(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found');
    }
    return [
      {
        'timestamp': DateTime.now().toIso8601String(),
        'action': 'LOGIN',
        'userId': userId,
        'ipAddress': '127.0.0.1',
        'userAgent': 'DartStream Test Client',
      },
      {
        'timestamp': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
        'action': 'PROFILE_UPDATE',
        'userId': userId,
        'ipAddress': '127.0.0.1',
        'userAgent': 'DartStream Test Client',
      },
    ];
  }

  Future<String> getUserFlowUrl(String userFlow) async {
    return 'https://test-tenant.b2clogin.com/test-tenant.onmicrosoft.com/oauth2/v2.0/authorize?p=$userFlow';
  }

  Future<String> getProfileEditUrl() async {
    return 'https://test-tenant.b2clogin.com/test-tenant.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_profile_edit';
  }

  Future<String> getPasswordResetUrl() async {
    return 'https://test-tenant.b2clogin.com/test-tenant.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_password_reset';
  }
}

void main() {
  group('Enhanced EntraID Auth Provider Tests', () {
    late MockEntraIDAuthProvider mockProvider;
    late DSAuthManager authManager;

    setUp(() async {
      mockProvider = MockEntraIDAuthProvider();
      
      // Initialize the provider
      await mockProvider.initialize({
        'tenantId': 'test-tenant-id',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'userFlow': 'B2C_1_signup_signin',
        'policyName': 'B2C_1_signup_signin',
        'domain': 'test-tenant.b2clogin.com',
      });
      
      // Register with auth manager
      DSAuthManager.registerProvider(
        'entraid',
        mockProvider,
        DSAuthProviderMetadata(
          type: 'EntraID',
          region: 'global',
          clientId: 'test-client-id',
        ),
      );
      authManager = DSAuthManager('entraid');
    });

    tearDown(() {
      // Clean up between tests
      DSAuthManager.enableDebugging = false;
      DSAuthManager.clearProviders();
    });

    test('Full Authentication Flow', () async {
      // Create account
      await mockProvider.createAccount(
        'test@example.com',
        'password123',
        displayName: 'Test User',
      );

      // Sign in
      await mockProvider.signIn('test@example.com', 'password123');

      // Verify current user
      final currentUser = await mockProvider.getCurrentUser();
      expect(currentUser.email, equals('test@example.com'));
      expect(currentUser.displayName, equals('Test User'));
      expect(currentUser.customAttributes?['provider'], equals('entraid'));

      // Verify token
      final isValid = await mockProvider.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.test');
      expect(isValid, isTrue);

      // Sign out
      await mockProvider.signOut();

      // Verify no current user
      expect(() => mockProvider.getCurrentUser(), throwsA(isA<DSAuthError>()));
    });

    test('EntraID User Profile Management', () async {
      // Create account
      await mockProvider.createAccount(
        'profile@example.com',
        'password123',
        displayName: 'Profile User',
      );

      await mockProvider.signIn('profile@example.com', 'password123');
      final user = await mockProvider.getCurrentUser();

      // Get user attributes
      final attributes = await mockProvider.getUserAttributes(user.id);
      expect(attributes['givenName'], equals('Profile'));
      expect(attributes['surname'], equals('User'));

      // Update profile
      await mockProvider.updateUserProfile(user.id, {
        'givenName': 'Updated',
        'surname': 'Profile',
        'city': 'New York',
      });

      final updatedAttributes = await mockProvider.getUserAttributes(user.id);
      expect(updatedAttributes['givenName'], equals('Updated'));
      expect(updatedAttributes['surname'], equals('Profile'));
      expect(updatedAttributes['city'], equals('New York'));
    });

    test('EntraID Multi-Factor Authentication', () async {
      // Create account
      await mockProvider.createAccount(
        'mfa@example.com',
        'password123',
        displayName: 'MFA User',
      );

      await mockProvider.signIn('mfa@example.com', 'password123');
      final user = await mockProvider.getCurrentUser();

      // Enable MFA
      await mockProvider.enableMFA(user.id);
      final attributes = await mockProvider.getUserAttributes(user.id);
      expect(attributes['mfa_enabled'], isTrue);

      // Disable MFA
      await mockProvider.disableMFA(user.id);
      final updatedAttributes = await mockProvider.getUserAttributes(user.id);
      expect(updatedAttributes['mfa_enabled'], isFalse);
    });

    test('EntraID Group Management', () async {
      // Create account
      await mockProvider.createAccount(
        'group@example.com',
        'password123',
        displayName: 'Group User',
      );

      await mockProvider.signIn('group@example.com', 'password123');
      final user = await mockProvider.getCurrentUser();

      // Check default groups
      final initialGroups = await mockProvider.getUserGroups(user.id);
      expect(initialGroups, contains('default_group'));

      // Assign to new group
      await mockProvider.assignUserToGroup(user.id, 'admin_group');
      final updatedGroups = await mockProvider.getUserGroups(user.id);
      expect(updatedGroups, contains('admin_group'));
      expect(updatedGroups, contains('default_group'));

      // Remove from group
      await mockProvider.removeUserFromGroup(user.id, 'default_group');
      final finalGroups = await mockProvider.getUserGroups(user.id);
      expect(finalGroups, contains('admin_group'));
      expect(finalGroups, isNot(contains('default_group')));
    });

    test('EntraID Audit Logging', () async {
      // Create account
      await mockProvider.createAccount(
        'audit@example.com',
        'password123',
        displayName: 'Audit User',
      );

      await mockProvider.signIn('audit@example.com', 'password123');
      final user = await mockProvider.getCurrentUser();

      // Get audit logs
      final logs = await mockProvider.getAuditLogs(user.id);
      expect(logs, isNotEmpty);
      expect(logs.first['action'], equals('LOGIN'));
      expect(logs.first['userId'], equals(user.id));
    });

    test('EntraID User Flow URLs', () async {
      // Test sign up/sign in flow URL
      final signUpUrl = await mockProvider.getUserFlowUrl('B2C_1_signup_signin');
      expect(signUpUrl, contains('B2C_1_signup_signin'));
      expect(signUpUrl, contains('test-tenant.b2clogin.com'));

      // Test profile edit URL
      final profileUrl = await mockProvider.getProfileEditUrl();
      expect(profileUrl, contains('B2C_1_profile_edit'));
      expect(profileUrl, contains('test-tenant.b2clogin.com'));

      // Test password reset URL
      final resetUrl = await mockProvider.getPasswordResetUrl();
      expect(resetUrl, contains('B2C_1_password_reset'));
      expect(resetUrl, contains('test-tenant.b2clogin.com'));
    });

    test('EntraID Password Reset Flow', () async {
      // Create account
      await mockProvider.createAccount(
        'reset@example.com',
        'password123',
        displayName: 'Reset User',
      );

      // Test password reset
      await mockProvider.resetPassword('reset@example.com');
      // This should not throw an error
    });

    test('EntraID Account Deletion', () async {
      // Create account
      await mockProvider.createAccount(
        'delete@example.com',
        'password123',
        displayName: 'Delete User',
      );

      await mockProvider.signIn('delete@example.com', 'password123');
      final user = await mockProvider.getCurrentUser();

      // Delete account
      await mockProvider.deleteAccount(user.id);

      // Verify account is deleted
      expect(() => mockProvider.getUser(user.id), throwsA(isA<DSAuthError>()));
    });

    test('EntraID Token Refresh', () async {
      // Create account
      await mockProvider.createAccount(
        'refresh@example.com',
        'password123',
        displayName: 'Refresh User',
      );

      await mockProvider.signIn('refresh@example.com', 'password123');

      // Test token refresh
      final newToken = await mockProvider.refreshToken('refresh_token_123');
      expect(newToken, isNotNull);
      expect(newToken, startsWith('eyJ'));
    });

    test('EntraID Error Handling', () async {
      // Test invalid credentials
      await mockProvider.createAccount(
        'error@example.com',
        'password123',
        displayName: 'Error User',
      );

      expect(
        () => mockProvider.signIn('error@example.com', 'wrong_password'),
        throwsA(isA<DSAuthError>()),
      );

      // Test duplicate account creation
      expect(
        () => mockProvider.createAccount('error@example.com', 'password123'),
        throwsA(isA<DSAuthError>()),
      );

      // Test operations on non-existent user
      expect(
        () => mockProvider.getUser('nonexistent_user'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('EntraID Provider Integration with Auth Manager', () async {
      final providers = DSAuthManager.getRegisteredProviders();
      expect(providers, contains('entraid'));

      final metadata = DSAuthManager.getProviderMetadata('entraid');
      expect(metadata?.type, equals('EntraID'));
      expect(metadata?.clientId, equals('test-client-id'));
    });
  });
}
