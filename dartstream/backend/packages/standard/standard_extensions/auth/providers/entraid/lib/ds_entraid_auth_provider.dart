// Import base authentication interfaces and types from DartStream core
import 'package:ds_auth_base/ds_auth_base_export.dart';

// Import http client for API calls

import 'src/ds_session_manager.dart';


/// Microsoft EntraID (Azure AD B2C) authentication provider implementation for DartStream.
class DSEntraIDAuthProvider implements DSAuthProvider {
  static DSEntraIDAuthProvider? _instance;
  bool _isInitialized = false;

  final String tenantId;
  final String clientId;
  final String clientSecret;
  final String primaryUserFlow;
  final String domain;
  final Map<String, String> userFlows;
  final List<String> scopes;

  DSAuthUser? _currentUser;

  final Map<String, DSAuthUser> _mockUsers = {};
  final Map<String, String> _mockPasswords = {};
  final Map<String, String> _mockTokens = {};

  DSEntraIDAuthProvider._internal({
    required this.tenantId,
    required this.clientId,
    required this.clientSecret,
    required this.primaryUserFlow,
    required this.domain,
    Map<String, String>? userFlows,
    List<String>? scopes,
  })  : userFlows = userFlows ?? {
          'signup_signin': 'B2C_1_signup_signin',
          'profile_edit': 'B2C_1_profile_edit',
          'password_reset': 'B2C_1_password_reset',
        },
        scopes = scopes ?? ['openid', 'profile', 'email'];

  factory DSEntraIDAuthProvider({
    required String tenantId,
    required String clientId,
    required String clientSecret,
    String primaryUserFlow = 'B2C_1_signup_signin',
    String? domain,
    Map<String, String>? userFlows,
    List<String>? scopes,
  }) {
    _instance ??= DSEntraIDAuthProvider._internal(
      tenantId: tenantId,
      clientId: clientId,
      clientSecret: clientSecret,
      primaryUserFlow: primaryUserFlow,
      domain: domain ?? '$tenantId.b2clogin.com',
      userFlows: userFlows,
      scopes: scopes,
    );
    return _instance!;
  }

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    try {
      print('Initializing EntraID provider...');
      print('Tenant ID: $tenantId');
      print('Client ID: $clientId');
      print('Domain: $domain');
      print('Primary User Flow: $primaryUserFlow');

      _isInitialized = true;
      print('EntraID provider initialized successfully');
    } catch (e) {
      throw DSAuthError(
        'Failed to initialize EntraID provider: $e',
        code: 500,
      );
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    if (!_isInitialized) {
      throw DSAuthError(
        'Provider not initialized',
        code: 500,
      );
    }

    try {
      if (_mockPasswords[email] == password) {
        _currentUser = _mockUsers[email];
        final token = _generateMockToken(email);
        _mockTokens[email] = token;
        
        final sessionManager = DSSessionManager();
        await sessionManager.storeSession(_currentUser!.id, token);
        
        await onLoginSuccess(_currentUser!);
      } else {
        throw DSAuthError(
          'Invalid credentials',
          code: 401,
        );
      }
    } catch (e) {
      if (e is DSAuthError) rethrow;
      throw DSAuthError(
        'Sign in failed: $e',
        code: 500,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (_currentUser != null) {
        final userEmail = _currentUser!.email;
        _mockTokens.remove(userEmail);
        
        final sessionManager = DSSessionManager();
        await sessionManager.clearSession(_currentUser!.id);
        
        _currentUser = null;
        await onLogout();
        print('EntraID sign out successful for: $userEmail');
      }
    } catch (e) {
      throw DSAuthError(
        'Sign out failed: $e',
        code: 500,
      );
    }
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    try {
      final user = _mockUsers.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw DSAuthError(
          'User not found: $userId',
          code: 404,
        ),
      );
      return user;
    } catch (e) {
      if (e is DSAuthError) rethrow;
      throw DSAuthError(
        'Get user failed: $e',
        code: 500,
      );
    }
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError(
        'No user is currently signed in',
        code: 401,
      );
    }
    return _currentUser!;
  }

  @override
  Future<void> createAccount(String email, String password,
      {String? displayName}) async {
    if (!_isInitialized) {
      throw DSAuthError(
        'Provider not initialized',
        code: 500,
      );
    }

    if (_mockUsers.containsKey(email)) {
      throw DSAuthError(
        'User already exists',
        code: 409,
      );
    }

    final user = DSAuthUser(
      id: 'entraid|${email.replaceAll('@', '_').replaceAll('.', '_')}',
      email: email,
      displayName: displayName ?? 'EntraID User',
      customAttributes: {
        'provider': 'entraid',
        'tenant_id': tenantId,
        'user_flow': primaryUserFlow,
        'email_verified': true,
        'created_at': DateTime.now().toIso8601String(),
        'groups': ['default_group'],
      },
    );

    _mockUsers[email] = user;
    _mockPasswords[email] = password;
    print('EntraID account created for: $email');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    try {
      if (token == null) return _currentUser != null;

      if (token.startsWith('eyJ') && token.contains('.')) {
        final userEmail = _mockTokens.entries
            .firstWhere(
              (entry) => entry.value == token,
              orElse: () => MapEntry('', ''),
            )
            .key;

        if (userEmail.isNotEmpty && _mockUsers.containsKey(userEmail)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    if (_currentUser == null) {
      throw DSAuthError(
        'No user signed in',
        code: 401,
      );
    }

    if (refreshToken.startsWith('refresh_token_')) {
      final newToken = _generateMockToken(_currentUser!.email);
      _mockTokens[_currentUser!.email] = newToken;
      return newToken;
    }

    throw DSAuthError(
      'Invalid refresh token',
      code: 400,
    );
  }

  String _generateMockToken(String email) {
    final header = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9';
    final payload = DateTime.now().millisecondsSinceEpoch.toString();
    final signature = 'entraid_signature_${email.hashCode}';
    return '$header.$payload.$signature';
  }

  Future<void> resetPassword(String email) async {
    if (!_mockUsers.containsKey(email)) {
      throw DSAuthError(
        'User not found',
        code: 404,
      );
    }
    print('Password reset initiated for: $email');
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    user.customAttributes?.addAll(updates);
    print('User profile updated for: $userId');
  }

  Future<void> deleteAccount(String userId) async {
    final userToDelete = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    _mockUsers.remove(userToDelete.email);
    _mockPasswords.remove(userToDelete.email);
    _mockTokens.remove(userToDelete.email);
    print('Account deleted for: $userId');
  }

  Future<Map<String, dynamic>> getUserAttributes(String userId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    return user.customAttributes ?? {};
  }

  Future<void> enableMFA(String userId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    user.customAttributes?['mfa_enabled'] = true;
    print('MFA enabled for: $userId');
  }

  Future<void> disableMFA(String userId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    user.customAttributes?['mfa_enabled'] = false;
    print('MFA disabled for: $userId');
  }

  Future<List<String>> getUserGroups(String userId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    return (user.customAttributes?['groups'] as List<dynamic>?)
            ?.cast<String>() ??
        ['default_group'];
  }

  Future<void> assignUserToGroup(String userId, String groupId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    final groups = (user.customAttributes?['groups'] as List<dynamic>?)
            ?.cast<String>() ??
        ['default_group'];
    if (!groups.contains(groupId)) groups.add(groupId);
    user.customAttributes?['groups'] = groups;
    print('User $userId assigned to group $groupId');
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

    final groups = (user.customAttributes?['groups'] as List<dynamic>?)
            ?.cast<String>() ??
        ['default_group'];
    groups.remove(groupId);
    user.customAttributes?['groups'] = groups;
    print('User $userId removed from group $groupId');
  }

  Future<List<Map<String, dynamic>>> getAuditLogs(String userId) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw DSAuthError(
        'User not found',
        code: 404,
      ),
    );

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
    return 'https://$domain/$tenantId.onmicrosoft.com/oauth2/v2.0/authorize?p=$userFlow';
  }

  Future<String> getProfileEditUrl() async {
    return 'https://$domain/$tenantId.onmicrosoft.com/oauth2/v2.0/authorize?p=${userFlows['profile_edit']}';
  }

  Future<String> getPasswordResetUrl() async {
    return 'https://$domain/$tenantId.onmicrosoft.com/oauth2/v2.0/authorize?p=${userFlows['password_reset']}';
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('EntraID login success hook called for: ${user.email}');
  }

  @override
  Future<void> onLogout() async {
    print('EntraID logout hook called');
  }
}
