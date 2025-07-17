import 'package:test/test.dart';

// Mock implementations for EntraID testing - these would normally come from ds_auth_base package

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

/// EntraID Provider Manager
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

/// Standalone EntraID Provider Implementation
class StandaloneEntraIDProvider implements DSAuthProvider {
  final String tenantId;
  final String clientId;
  final String clientSecret;
  final String userFlow;
  final String policyName;
  final String domain;

  bool _isInitialized = false;
  DSAuthUser? _currentUser;
  final Map<String, DSAuthUser> _users = {};
  final Map<String, String> _passwords = {};
  final Map<String, String> _tokens = {};
  final Map<String, List<String>> _userGroups = {};
  final Map<String, Map<String, dynamic>> _userAttributes = {};

  StandaloneEntraIDProvider({
    required this.tenantId,
    required this.clientId,
    required this.clientSecret,
    required this.userFlow,
    required this.policyName,
    required this.domain,
  });

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _isInitialized = true;
    print('Standalone EntraID Provider initialized');
    print('Tenant ID: $tenantId');
    print('Client ID: $clientId');
    print('Domain: $domain');
    print('User Flow: $userFlow');
  }

  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) {
      throw DSAuthError('Provider not initialized');
    }

    if (_passwords[username] == password) {
      _currentUser = _users[username];
      final token = _generateToken(username);
      _tokens[username] = token;
      await onLoginSuccess(_currentUser!);
      print('EntraID sign in successful for: $username');
    } else {
      throw DSAuthError('Invalid credentials', code: 401);
    }
  }

  @override
  Future<void> signOut() async {
    if (_currentUser != null) {
      _tokens.remove(_currentUser!.email);
      _currentUser = null;
      await onLogout();
      print('EntraID sign out successful');
    }
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError('User not found: $userId', code: 404),
    );
    return user;
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in', code: 401);
    }
    return _currentUser!;
  }

  @override
  Future<void> createAccount(String email, String password, {String? displayName}) async {
    if (!_isInitialized) {
      throw DSAuthError('Provider not initialized');
    }

    if (_users.containsKey(email)) {
      throw DSAuthError('User already exists', code: 409);
    }

    final user = DSAuthUser(
      id: 'entraid|${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'EntraID User',
      customAttributes: {
        'provider': 'entraid',
        'tenant_id': tenantId,
        'user_flow': userFlow,
        'email_verified': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    );

    _users[email] = user;
    _passwords[email] = password;
    _userGroups[user.id] = ['default_group'];
    _userAttributes[user.id] = {
      'givenName': displayName?.split(' ').first ?? 'User',
      'surname': displayName?.split(' ').last ?? 'Name',
      'country': 'US',
      'city': 'Seattle',
      'jobTitle': 'Software Engineer',
      'mfa_enabled': false,
    };

    print('EntraID account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    if (token == null) {
      return _currentUser != null;
    }

    // Mock JWT token validation
    if (token.startsWith('eyJ') && token.contains('.')) {
      final userEmail = _tokens.entries
          .firstWhere(
            (entry) => entry.value == token,
            orElse: () => MapEntry('', ''),
          )
          .key;
      
      if (userEmail.isNotEmpty && _users.containsKey(userEmail)) {
        return true;
      }
    }
    
    return false;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (_currentUser == null) {
      throw DSAuthError('No user signed in', code: 401);
    }

    // Mock token refresh
    if (refreshToken.startsWith('refresh_token_')) {
      final newToken = _generateToken(_currentUser!.email);
      _tokens[_currentUser!.email] = newToken;
      return newToken;
    }

    throw DSAuthError('Invalid refresh token', code: 401);
  }

  String _generateToken(String email) {
    final header = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9';
    final payload = DateTime.now().millisecondsSinceEpoch.toString();
    final signature = 'entraid_signature_${email.hashCode}';
    return '$header.$payload.$signature';
  }

  // EntraID-specific methods
  Future<void> resetPassword(String email) async {
    if (!_users.containsKey(email)) {
      throw DSAuthError('User not found', code: 404);
    }
    print('Password reset initiated for: $email');
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    _userAttributes[userId]!.addAll(updates);
    print('User profile updated for: $userId');
  }

  Future<void> deleteAccount(String userId) async {
    final userToDelete = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError('User not found', code: 404),
    );

    _users.remove(userToDelete.email);
    _passwords.remove(userToDelete.email);
    _tokens.remove(userToDelete.email);
    _userGroups.remove(userId);
    _userAttributes.remove(userId);
    print('Account deleted for: $userId');
  }

  Future<Map<String, dynamic>> getUserAttributes(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    return Map.from(_userAttributes[userId]!);
  }

  Future<void> enableMFA(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    _userAttributes[userId]!['mfa_enabled'] = true;
    print('MFA enabled for: $userId');
  }

  Future<void> disableMFA(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    _userAttributes[userId]!['mfa_enabled'] = false;
    print('MFA disabled for: $userId');
  }

  Future<List<String>> getUserGroups(String userId) async {
    if (!_userGroups.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    return List.from(_userGroups[userId]!);
  }

  Future<void> assignUserToGroup(String userId, String groupId) async {
    if (!_userGroups.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    if (!_userGroups[userId]!.contains(groupId)) {
      _userGroups[userId]!.add(groupId);
    }
    print('User $userId assigned to group $groupId');
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    if (!_userGroups.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    _userGroups[userId]!.remove(groupId);
    print('User $userId removed from group $groupId');
  }

  Future<List<Map<String, dynamic>>> getAuditLogs(String userId) async {
    if (!_userAttributes.containsKey(userId)) {
      throw DSAuthError('User not found', code: 404);
    }
    return [
      {
        'timestamp': DateTime.now().toIso8601String(),
        'action': 'LOGIN',
        'userId': userId,
        'ipAddress': '127.0.0.1',
        'userAgent': 'DartStream Test Client',
        'location': 'Seattle, WA',
      },
      {
        'timestamp': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
        'action': 'PROFILE_UPDATE',
        'userId': userId,
        'ipAddress': '127.0.0.1',
        'userAgent': 'DartStream Test Client',
        'location': 'Seattle, WA',
      },
      {
        'timestamp': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'action': 'PASSWORD_CHANGE',
        'userId': userId,
        'ipAddress': '192.168.1.100',
        'userAgent': 'DartStream Web Client',
        'location': 'Portland, OR',
      },
    ];
  }

  Future<String> getUserFlowUrl(String userFlow) async {
    return 'https://$domain/$tenantId.onmicrosoft.com/oauth2/v2.0/authorize?p=$userFlow&client_id=$clientId&response_type=code&redirect_uri=https://localhost:8080/callback';
  }

  Future<String> getProfileEditUrl() async {
    return 'https://$domain/$tenantId.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_profile_edit&client_id=$clientId&response_type=code&redirect_uri=https://localhost:8080/callback';
  }

  Future<String> getPasswordResetUrl() async {
    return 'https://$domain/$tenantId.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_password_reset&client_id=$clientId&response_type=code&redirect_uri=https://localhost:8080/callback';
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('EntraID login success hook called for: ${user.email}');
    // Additional EntraID-specific login logic could go here
  }

  @override
  Future<void> onLogout() async {
    print('EntraID logout hook called');
    // Additional EntraID-specific logout logic could go here
  }
}

void main() {
  group('Standalone EntraID Provider Tests', () {
    late StandaloneEntraIDProvider provider;
    late DSAuthManager authManager;

    setUp(() async {
      provider = StandaloneEntraIDProvider(
        tenantId: 'test-tenant',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        userFlow: 'B2C_1_signup_signin',
        policyName: 'B2C_1_signup_signin',
        domain: 'test-tenant.b2clogin.com',
      );

      await provider.initialize({});
      DSAuthManager.registerProvider('entraid', provider);
      authManager = DSAuthManager('entraid');
    });

    test('Standalone Provider Initialization', () async {
      expect(provider.tenantId, equals('test-tenant'));
      expect(provider.clientId, equals('test-client-id'));
      expect(provider.userFlow, equals('B2C_1_signup_signin'));
      expect(provider.domain, equals('test-tenant.b2clogin.com'));
    });

    test('Complete Authentication Workflow', () async {
      // Step 1: Create account
      await authManager.createAccount(
        'workflow@example.com',
        'password123',
        displayName: 'Workflow User',
      );

      // Step 2: Sign in
      await authManager.signIn('workflow@example.com', 'password123');

      // Step 3: Verify current user
      final currentUser = await authManager.getCurrentUser();
      expect(currentUser.email, equals('workflow@example.com'));
      expect(currentUser.displayName, equals('Workflow User'));
      expect(currentUser.customAttributes!['provider'], equals('entraid'));
      expect(currentUser.customAttributes!['tenant_id'], equals('test-tenant'));

      // Step 4: Token verification
      final isValid = await authManager.verifyToken();
      expect(isValid, isTrue);

      // Step 5: Get user attributes
      final attributes = await provider.getUserAttributes(currentUser.id);
      expect(attributes['givenName'], equals('Workflow'));
      expect(attributes['surname'], equals('User'));
      expect(attributes['mfa_enabled'], isFalse);

      // Step 6: Sign out
      await authManager.signOut();

      // Step 7: Verify no current user
      expect(() => authManager.getCurrentUser(), throwsA(isA<DSAuthError>()));
    });

    test('EntraID User Management Features', () async {
      // Create and sign in user
      await authManager.createAccount(
        'management@example.com',
        'password123',
        displayName: 'Management User',
      );
      await authManager.signIn('management@example.com', 'password123');
      final user = await authManager.getCurrentUser();

      // Test profile updates
      await provider.updateUserProfile(user.id, {
        'jobTitle': 'Senior Engineer',
        'department': 'Engineering',
        'location': 'New York',
      });

      final updatedAttributes = await provider.getUserAttributes(user.id);
      expect(updatedAttributes['jobTitle'], equals('Senior Engineer'));
      expect(updatedAttributes['department'], equals('Engineering'));
      expect(updatedAttributes['location'], equals('New York'));

      // Test MFA management
      await provider.enableMFA(user.id);
      final mfaEnabled = await provider.getUserAttributes(user.id);
      expect(mfaEnabled['mfa_enabled'], isTrue);

      await provider.disableMFA(user.id);
      final mfaDisabled = await provider.getUserAttributes(user.id);
      expect(mfaDisabled['mfa_enabled'], isFalse);

      // Test group management
      final initialGroups = await provider.getUserGroups(user.id);
      expect(initialGroups, contains('default_group'));

      await provider.assignUserToGroup(user.id, 'admin_group');
      final withAdminGroup = await provider.getUserGroups(user.id);
      expect(withAdminGroup, contains('admin_group'));

      await provider.removeUserFromGroup(user.id, 'default_group');
      final withoutDefaultGroup = await provider.getUserGroups(user.id);
      expect(withoutDefaultGroup, isNot(contains('default_group')));
    });

    test('EntraID B2C User Flows', () async {
      // Test sign up/sign in flow URL
      final signUpUrl = await provider.getUserFlowUrl('B2C_1_signup_signin');
      expect(signUpUrl, contains('B2C_1_signup_signin'));
      expect(signUpUrl, contains('test-tenant.b2clogin.com'));
      expect(signUpUrl, contains('test-client-id'));

      // Test profile edit URL
      final profileUrl = await provider.getProfileEditUrl();
      expect(profileUrl, contains('B2C_1_profile_edit'));
      expect(profileUrl, contains('test-tenant.b2clogin.com'));

      // Test password reset URL
      final resetUrl = await provider.getPasswordResetUrl();
      expect(resetUrl, contains('B2C_1_password_reset'));
      expect(resetUrl, contains('test-tenant.b2clogin.com'));
    });

    test('EntraID Audit and Monitoring', () async {
      // Create and sign in user
      await authManager.createAccount(
        'audit@example.com',
        'password123',
        displayName: 'Audit User',
      );
      await authManager.signIn('audit@example.com', 'password123');
      final user = await authManager.getCurrentUser();

      // Test audit logs
      final logs = await provider.getAuditLogs(user.id);
      expect(logs, isNotEmpty);
      expect(logs.length, greaterThanOrEqualTo(3));

      final loginLog = logs.firstWhere((log) => log['action'] == 'LOGIN');
      expect(loginLog['userId'], equals(user.id));
      expect(loginLog['ipAddress'], isNotNull);
      expect(loginLog['userAgent'], isNotNull);
      expect(loginLog['location'], isNotNull);

      final profileUpdateLog = logs.firstWhere((log) => log['action'] == 'PROFILE_UPDATE');
      expect(profileUpdateLog['userId'], equals(user.id));

      final passwordChangeLog = logs.firstWhere((log) => log['action'] == 'PASSWORD_CHANGE');
      expect(passwordChangeLog['userId'], equals(user.id));
    });

    test('EntraID Token Management', () async {
      // Create and sign in user
      await authManager.createAccount(
        'token@example.com',
        'password123',
        displayName: 'Token User',
      );
      await authManager.signIn('token@example.com', 'password123');

      // Test token verification
      final isValid = await authManager.verifyToken();
      expect(isValid, isTrue);

      // Test token refresh
      final newToken = await authManager.refreshToken('refresh_token_123');
      expect(newToken, isNotNull);
      expect(newToken, startsWith('eyJ'));
      expect(newToken, contains('.'));

      // Test token verification with explicit token
      final isValidExplicit = await authManager.verifyToken(newToken);
      expect(isValidExplicit, isTrue);
    });

    test('EntraID Error Handling', () async {
      // Test invalid credentials
      await authManager.createAccount(
        'error@example.com',
        'password123',
        displayName: 'Error User',
      );

      expect(
        () => authManager.signIn('error@example.com', 'wrong_password'),
        throwsA(predicate((e) => e is DSAuthError && e.code == 401)),
      );

      // Test duplicate account creation
      expect(
        () => authManager.createAccount('error@example.com', 'password123'),
        throwsA(predicate((e) => e is DSAuthError && e.code == 409)),
      );

      // Test operations on non-existent user
      expect(
        () => provider.getUser('nonexistent_user'),
        throwsA(predicate((e) => e is DSAuthError && e.code == 404)),
      );

      expect(
        () => provider.getUserAttributes('nonexistent_user'),
        throwsA(predicate((e) => e is DSAuthError && e.code == 404)),
      );
    });

    test('EntraID Password Reset Flow', () async {
      // Create user
      await authManager.createAccount(
        'reset@example.com',
        'password123',
        displayName: 'Reset User',
      );

      // Test password reset - should not throw
      await provider.resetPassword('reset@example.com');

      // Test password reset for non-existent user
      expect(
        () => provider.resetPassword('nonexistent@example.com'),
        throwsA(predicate((e) => e is DSAuthError && e.code == 404)),
      );
    });

    test('EntraID Account Deletion', () async {
      // Create and sign in user
      await authManager.createAccount(
        'delete@example.com',
        'password123',
        displayName: 'Delete User',
      );
      await authManager.signIn('delete@example.com', 'password123');
      final user = await authManager.getCurrentUser();

      // Verify user exists
      final userBefore = await provider.getUser(user.id);
      expect(userBefore.id, equals(user.id));

      // Delete account
      await provider.deleteAccount(user.id);

      // Verify user no longer exists
      expect(
        () => provider.getUser(user.id),
        throwsA(predicate((e) => e is DSAuthError && e.code == 404)),
      );

      // Verify attributes are cleaned up
      expect(
        () => provider.getUserAttributes(user.id),
        throwsA(predicate((e) => e is DSAuthError && e.code == 404)),
      );
    });

    test('EntraID Integration with Auth Manager', () async {
      // Test that the provider is properly registered
      expect(() => DSAuthManager('entraid'), returnsNormally);

      // Test that unregistered provider throws error
      expect(
        () => DSAuthManager('nonexistent'),
        throwsA(isA<DSAuthError>()),
      );

      // Test auth manager delegates to provider correctly
      await authManager.createAccount(
        'manager@example.com',
        'password123',
        displayName: 'Manager User',
      );

      await authManager.signIn('manager@example.com', 'password123');
      final user = await authManager.getCurrentUser();

      expect(user.email, equals('manager@example.com'));
      expect(user.displayName, equals('Manager User'));
    });
  });
}
