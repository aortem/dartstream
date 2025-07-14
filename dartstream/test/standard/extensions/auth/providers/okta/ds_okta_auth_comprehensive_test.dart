import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/okta/lib/ds_okta_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

void main() {
  group('Comprehensive Okta Auth Provider Tests', () {
    late DSOktaAuthProvider oktaProvider;
    
    setUp(() {
      oktaProvider = DSOktaAuthProvider();
    });

    group('Initialization Tests', () {
      test('should initialize with complete configuration', () async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });

        expect(oktaProvider, isNotNull);
      });

      test('should throw exception with missing oktaDomain', () async {
        try {
          await oktaProvider.initialize({
            'clientId': 'test-client-id',
            'clientSecret': 'test-client-secret',
            'redirectUri': 'https://example.com/callback',
          });
          fail('Expected initialization to throw');
        } catch (e) {
          expect(e, isA<Exception>());
          expect(e.toString(), contains('Missing required Okta configuration'));
        }
      });

      test('should throw exception with missing clientId', () async {
        try {
          await oktaProvider.initialize({
            'oktaDomain': 'dev-123456.okta.com',
            'clientSecret': 'test-client-secret',
            'redirectUri': 'https://example.com/callback',
          });
          fail('Expected initialization to throw');
        } catch (e) {
          expect(e, isA<Exception>());
          expect(e.toString(), contains('Missing required Okta configuration'));
        }
      });
    });

    group('Authentication Flow Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
      });

      test('should complete full authentication flow', () async {
        // Sign in
        await oktaProvider.signIn('user@example.com', 'password123');
        
        // Verify current user
        final currentUser = await oktaProvider.getCurrentUser();
        expect(currentUser.email, equals('user@example.com'));
        expect(currentUser.id, equals('okta_user_example_com'));
        expect(currentUser.customAttributes?['provider'], equals('okta'));
        
        // Verify token
        final isTokenValid = await oktaProvider.verifyToken();
        expect(isTokenValid, isTrue);
        
        // Sign out
        await oktaProvider.signOut();
        
        // Verify no current user
        try {
          await oktaProvider.getCurrentUser();
          fail('Expected getCurrentUser to throw');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle account creation and immediate sign in', () async {
        await oktaProvider.createAccount('newuser@example.com', 'password123', 
          displayName: 'New User');
        
        await oktaProvider.signIn('newuser@example.com', 'password123');
        
        final user = await oktaProvider.getCurrentUser();
        expect(user.email, equals('newuser@example.com'));
        expect(user.displayName, equals('New User'));
      });

      test('should create account with custom attributes', () async {
        await oktaProvider.createAccount('custom@example.com', 'password123');
        
        final user = await oktaProvider.getUser('okta_custom_example_com');
        expect(user.customAttributes?['provider'], equals('okta'));
      });
    });

    group('User Management Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
        
        await oktaProvider.signIn('manager@example.com', 'password123');
      });

      test('should retrieve user by ID', () async {
        final user = await oktaProvider.getUser('okta_manager_example_com');
        expect(user.email, equals('manager@example.com'));
        expect(user.id, equals('okta_manager_example_com'));
      });

      test('should create mock user when user ID not found', () async {
        final user = await oktaProvider.getUser('okta_nonexistent_example_com');
        expect(user.email, equals('nonexistent@example.com'));
        expect(user.id, equals('okta_nonexistent_example_com'));
      });
    });

    group('Token Management Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
        
        await oktaProvider.signIn('token@example.com', 'password123');
      });

      test('should refresh token successfully', () async {
        final originalToken = await oktaProvider.verifyToken();
        expect(originalToken, isTrue);
        
        final newToken = await oktaProvider.refreshToken('mock-refresh-token');
        expect(newToken, isNotNull);
        expect(newToken, contains('refreshed_token_'));
        expect(newToken, contains('okta_token_example_com'));
      });

      test('should verify token correctly', () async {
        final isValid = await oktaProvider.verifyToken();
        expect(isValid, isTrue);
      });

      test('should return false for token verification when no user signed in', () async {
        await oktaProvider.signOut();
        
        final isValid = await oktaProvider.verifyToken();
        expect(isValid, isFalse);
      });

      test('should throw exception when refreshing token without user', () async {
        await oktaProvider.signOut();
        
        try {
          await oktaProvider.refreshToken('mock-refresh-token');
          fail('Expected refreshToken to throw');
        } catch (e) {
          expect(e, isA<Exception>());
          expect(e.toString(), contains('No user signed in'));
        }
      });
    });

    group('Multi-Factor Authentication Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
        
        await oktaProvider.signIn('mfa@example.com', 'password123');
      });

      test('should enable MFA with SMS factor', () async {
        await oktaProvider.enableMFA('SMS');
        
        final user = await oktaProvider.getCurrentUser();
        expect(user.customAttributes?['mfaEnabled'], isTrue);
        expect(user.customAttributes?['mfaFactor'], equals('SMS'));
      });

      test('should enable MFA with TOTP factor', () async {
        await oktaProvider.enableMFA('TOTP');
        
        final user = await oktaProvider.getCurrentUser();
        expect(user.customAttributes?['mfaEnabled'], isTrue);
        expect(user.customAttributes?['mfaFactor'], equals('TOTP'));
      });

      test('should disable MFA', () async {
        await oktaProvider.enableMFA('SMS');
        await oktaProvider.disableMFA();
        
        final user = await oktaProvider.getCurrentUser();
        expect(user.customAttributes?['mfaEnabled'], isFalse);
        expect(user.customAttributes?['mfaFactor'], isNull);
      });

      test('should throw exception when enabling MFA without signed in user', () async {
        await oktaProvider.signOut();
        
        try {
          await oktaProvider.enableMFA('SMS');
          fail('Expected enableMFA to throw');
        } catch (e) {
          expect(e, isA<Exception>());
          expect(e.toString(), contains('No user signed in'));
        }
      });
    });

    group('Group Management Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
        
        await oktaProvider.signIn('groupuser@example.com', 'password123');
      });

      test('should get default groups for user', () async {
        final groups = await oktaProvider.getUserGroups('okta_groupuser_example_com');
        expect(groups, contains('DefaultGroup'));
      });

      test('should assign user to group', () async {
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'AdminGroup');
        
        final groups = await oktaProvider.getUserGroups('okta_groupuser_example_com');
        expect(groups, contains('AdminGroup'));
      });

      test('should not duplicate groups when assigning same group twice', () async {
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'AdminGroup');
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'AdminGroup');
        
        final groups = await oktaProvider.getUserGroups('okta_groupuser_example_com');
        expect(groups.where((g) => g == 'AdminGroup').length, equals(1));
      });

      test('should remove user from group', () async {
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'AdminGroup');
        await oktaProvider.removeUserFromGroup('okta_groupuser_example_com', 'AdminGroup');
        
        final groups = await oktaProvider.getUserGroups('okta_groupuser_example_com');
        expect(groups, isNot(contains('AdminGroup')));
      });

      test('should assign user to multiple groups', () async {
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'AdminGroup');
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'UserGroup');
        await oktaProvider.assignUserToGroup('okta_groupuser_example_com', 'DeveloperGroup');
        
        final groups = await oktaProvider.getUserGroups('okta_groupuser_example_com');
        expect(groups, contains('AdminGroup'));
        expect(groups, contains('UserGroup'));
        expect(groups, contains('DeveloperGroup'));
      });
    });

    group('Password Management Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
      });

      test('should reset password successfully', () async {
        // This should not throw an exception
        await oktaProvider.resetPassword('reset@example.com');
      });

      test('should throw exception when resetting password without initialization', () async {
        final uninitializedProvider = DSOktaAuthProvider();
        
        try {
          await uninitializedProvider.resetPassword('reset@example.com');
          fail('Expected resetPassword to throw');
        } catch (e) {
          expect(e, isA<Exception>());
          expect(e.toString(), contains('Okta provider not initialized'));
        }
      });
    });

    group('Audit Logging Tests', () {
      setUp(() async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
        
        await oktaProvider.signIn('audit@example.com', 'password123');
      });

      test('should get audit logs for user', () async {
        final logs = await oktaProvider.getAuditLogs('okta_audit_example_com');
        
        expect(logs, isNotEmpty);
        expect(logs.length, equals(2));
        expect(logs[0]['event'], equals('user.authentication.auth'));
        expect(logs[0]['userId'], equals('okta_audit_example_com'));
        expect(logs[0]['result'], equals('SUCCESS'));
        expect(logs[1]['event'], equals('user.session.start'));
      });

      test('should include timestamps in audit logs', () async {
        final logs = await oktaProvider.getAuditLogs('okta_audit_example_com');
        
        for (final log in logs) {
          expect(log['timestamp'], isNotNull);
          expect(log['timestamp'], isA<String>());
          
          // Verify timestamp format
          final timestamp = DateTime.tryParse(log['timestamp']);
          expect(timestamp, isNotNull);
        }
      });

      test('should throw exception when getting audit logs without initialization', () async {
        final uninitializedProvider = DSOktaAuthProvider();
        
        try {
          await uninitializedProvider.getAuditLogs('test-user');
          fail('Expected getAuditLogs to throw');
        } catch (e) {
          expect(e, isA<Exception>());
          expect(e.toString(), contains('Okta provider not initialized'));
        }
      });
    });

    group('Error Handling Tests', () {
      test('should throw exception for all methods when not initialized', () async {
        final uninitializedProvider = DSOktaAuthProvider();
        
        // Test all methods throw when not initialized
        expect(() => uninitializedProvider.signIn('test@example.com', 'password'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.signOut(),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.getCurrentUser(),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.getUser('test-user'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.verifyToken(),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.refreshToken('token'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.createAccount('test@example.com', 'password'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.enableMFA('SMS'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.disableMFA(),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.getUserGroups('test-user'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.assignUserToGroup('test-user', 'group'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.removeUserFromGroup('test-user', 'group'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.resetPassword('test@example.com'),
            throwsA(isA<Exception>()));
        expect(() => uninitializedProvider.getAuditLogs('test-user'),
            throwsA(isA<Exception>()));
      });

      test('should handle exceptions in sign in gracefully', () async {
        await oktaProvider.initialize({
          'oktaDomain': 'dev-123456.okta.com',
          'clientId': 'test-client-id',
          'clientSecret': 'test-client-secret',
          'redirectUri': 'https://example.com/callback',
        });
        
        // Should not throw for any valid email/password combination
        await oktaProvider.signIn('any@example.com', 'anypassword');
        
        final user = await oktaProvider.getCurrentUser();
        expect(user.email, equals('any@example.com'));
      });
    });
  });
}
