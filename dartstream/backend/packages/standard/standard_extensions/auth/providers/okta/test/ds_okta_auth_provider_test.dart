import 'package:test/test.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_okta_auth_provider/ds_okta_auth_export.dart';

void main() {
  group('DSOktaAuthProvider', () {
    late DSOktaAuthProvider provider;
    final testConfig = {
      'oktaDomain': 'dev-12345.okta.com',
      'clientId': 'test_client_id',
      'clientSecret': 'test_client_secret',
      'redirectUri': 'http://localhost:3000/callback',
    };

    setUp(() {
      provider = DSOktaAuthProvider();
    });

    test('initialize with valid config', () async {
      await provider.initialize(testConfig);
      expect(true, isTrue); // If no exception, initialization succeeded
    });

    test('initialize throws error with missing config', () async {
      final invalidConfig = {
        'oktaDomain': 'dev-12345.okta.com',
        // Missing clientId and clientSecret
      };
      
      expect(
        () => provider.initialize(invalidConfig),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('createAccount creates a new user', () async {
      await provider.initialize(testConfig);
      await provider.createAccount(
        'test@example.com',
        'password123',
        displayName: 'Test User',
      );
      
      // Verify user was created by signing in
      await provider.signIn('test@example.com', 'password123');
      final user = await provider.getCurrentUser();
      
      expect(user.email, equals('test@example.com'));
      expect(user.displayName, equals('Test User'));
    });

    test('signIn with existing user', () async {
      await provider.initialize(testConfig);
      await provider.createAccount('user@example.com', 'pass123');
      await provider.signIn('user@example.com', 'pass123');
      
      final user = await provider.getCurrentUser();
      expect(user.email, equals('user@example.com'));
    });

    test('signIn creates user if not exists', () async {
      await provider.initialize(testConfig);
      await provider.signIn('newuser@example.com', 'newpass');
      
      final user = await provider.getCurrentUser();
      expect(user.email, equals('newuser@example.com'));
    });

    test('getCurrentUser throws when no user signed in', () async {
      await provider.initialize(testConfig);
      
      expect(
        () => provider.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('signOut clears current user', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      // Verify user is signed in
      final user = await provider.getCurrentUser();
      expect(user, isNotNull);
      
      // Sign out
      await provider.signOut();
      
      // Verify user is no longer signed in
      expect(
        () => provider.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('getUser retrieves user by ID', () async {
      await provider.initialize(testConfig);
      await provider.createAccount('test@example.com', 'pass123');
      await provider.signIn('test@example.com', 'pass123');
      
      final currentUser = await provider.getCurrentUser();
      final retrievedUser = await provider.getUser(currentUser.id);
      
      expect(retrievedUser.id, equals(currentUser.id));
      expect(retrievedUser.email, equals(currentUser.email));
    });

    test('verifyToken returns true for valid token', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final isValid = await provider.verifyToken();
      expect(isValid, isTrue);
    });

    test('verifyToken returns false when no user signed in', () async {
      await provider.initialize(testConfig);
      
      final isValid = await provider.verifyToken();
      expect(isValid, isFalse);
    });

    test('refreshToken generates new token', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final newToken = await provider.refreshToken('old_refresh_token');
      expect(newToken, isNotEmpty);
      expect(newToken, contains('refreshed_token_'));
    });

    test('refreshToken throws when no user signed in', () async {
      await provider.initialize(testConfig);
      
      expect(
        () => provider.refreshToken('refresh_token'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('enableMFA adds MFA to user attributes', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      await provider.enableMFA('sms');
      final user = await provider.getCurrentUser();
      
      expect(user.customAttributes?['mfaEnabled'], isTrue);
      expect(user.customAttributes?['mfaFactor'], equals('sms'));
    });

    test('disableMFA removes MFA from user attributes', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      // First enable MFA
      await provider.enableMFA('sms');
      var user = await provider.getCurrentUser();
      expect(user.customAttributes?['mfaEnabled'], isTrue);
      
      // Then disable it
      await provider.disableMFA();
      user = await provider.getCurrentUser();
      expect(user.customAttributes?['mfaEnabled'], isFalse);
      expect(user.customAttributes?.containsKey('mfaFactor'), isFalse);
    });

    test('getUserGroups returns default group for new user', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final currentUser = await provider.getCurrentUser();
      final groups = await provider.getUserGroups(currentUser.id);
      
      expect(groups, contains('DefaultGroup'));
    });

    test('assignUserToGroup adds user to group', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final currentUser = await provider.getCurrentUser();
      await provider.assignUserToGroup(currentUser.id, 'Admins');
      
      final groups = await provider.getUserGroups(currentUser.id);
      expect(groups, contains('Admins'));
    });

    test('removeUserFromGroup removes user from group', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final currentUser = await provider.getCurrentUser();
      await provider.assignUserToGroup(currentUser.id, 'Admins');
      
      var groups = await provider.getUserGroups(currentUser.id);
      expect(groups, contains('Admins'));
      
      await provider.removeUserFromGroup(currentUser.id, 'Admins');
      groups = await provider.getUserGroups(currentUser.id);
      expect(groups, isNot(contains('Admins')));
    });

    test('resetPassword completes without error', () async {
      await provider.initialize(testConfig);
      
      // This should complete without throwing
      await provider.resetPassword('user@example.com');
      expect(true, isTrue);
    });

    test('getAuditLogs returns audit log entries', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final currentUser = await provider.getCurrentUser();
      final logs = await provider.getAuditLogs(currentUser.id);
      
      expect(logs, isNotEmpty);
      expect(logs.length, greaterThanOrEqualTo(2));
      expect(logs.first['event'], isNotNull);
      expect(logs.first['userId'], equals(currentUser.id));
    });

    test('operations throw when provider not initialized', () async {
      final uninitializedProvider = DSOktaAuthProvider();
      
      expect(
        () => uninitializedProvider.signIn('user@example.com', 'pass'),
        throwsA(isA<DSAuthError>()),
      );
      
      expect(
        () => uninitializedProvider.getCurrentUser(),
        throwsA(isA<DSAuthError>()),
      );
      
      expect(
        () => uninitializedProvider.createAccount('user@example.com', 'pass'),
        throwsA(isA<DSAuthError>()),
      );
    });

    test('user attributes include provider info', () async {
      await provider.initialize(testConfig);
      await provider.signIn('user@example.com', 'pass123');
      
      final user = await provider.getCurrentUser();
      expect(user.customAttributes?['provider'], equals('okta'));
    });

    test('multiple users can be created and retrieved', () async {
      await provider.initialize(testConfig);
      
      // Create multiple users
      await provider.createAccount('user1@example.com', 'pass1', displayName: 'User One');
      await provider.createAccount('user2@example.com', 'pass2', displayName: 'User Two');
      
      // Sign in as user1
      await provider.signIn('user1@example.com', 'pass1');
      var user = await provider.getCurrentUser();
      expect(user.displayName, equals('User One'));
      
      // Sign out and sign in as user2
      await provider.signOut();
      await provider.signIn('user2@example.com', 'pass2');
      user = await provider.getCurrentUser();
      expect(user.displayName, equals('User Two'));
    });

    test('lifecycle hooks are called', () async {
      var loginSuccessCalled = false;
      var logoutCalled = false;
      
      final customProvider = _CustomOktaProvider(
        onLoginSuccessCallback: (_) async {
          loginSuccessCalled = true;
        },
        onLogoutCallback: () async {
          logoutCalled = true;
        },
      );
      
      await customProvider.initialize(testConfig);
      await customProvider.signIn('user@example.com', 'pass123');
      expect(loginSuccessCalled, isTrue);
      
      await customProvider.signOut();
      expect(logoutCalled, isTrue);
    });
  });
}

// Helper class to test lifecycle hooks
class _CustomOktaProvider extends DSOktaAuthProvider {
  final Future<void> Function(DSAuthUser)? onLoginSuccessCallback;
  final Future<void> Function()? onLogoutCallback;

  _CustomOktaProvider({
    this.onLoginSuccessCallback,
    this.onLogoutCallback,
  });

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    await super.onLoginSuccess(user);
    if (onLoginSuccessCallback != null) {
      await onLoginSuccessCallback!(user);
    }
  }

  @override
  Future<void> onLogout() async {
    await super.onLogout();
    if (onLogoutCallback != null) {
      await onLogoutCallback!();
    }
  }
}