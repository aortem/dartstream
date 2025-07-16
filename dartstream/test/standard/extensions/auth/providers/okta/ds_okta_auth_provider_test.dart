import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/okta/lib/ds_okta_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

void main() {
  group('Okta Auth Provider Tests', () {
    late DSOktaAuthProvider oktaProvider;
    
    setUp(() {
      oktaProvider = DSOktaAuthProvider();
    });

    test('should initialize successfully with valid config', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      expect(oktaProvider, isNotNull);
    });

    test('should throw exception when initializing with invalid config', () async {
      try {
        await oktaProvider.initialize({
          'oktaDomain': 'test.okta.com',
          // Missing required fields
        });
        fail('Expected initialize to throw');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should create account successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.createAccount('test@example.com', 'password123');
      
      final user = await oktaProvider.getUser('okta_test_example_com');
      expect(user.email, equals('test@example.com'));
    });

    test('should sign in successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      
      final user = await oktaProvider.getCurrentUser();
      expect(user.email, equals('test@example.com'));
    });

    test('should sign out successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      await oktaProvider.signOut();
      
      try {
        await oktaProvider.getCurrentUser();
        fail('Expected getCurrentUser to throw');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should verify token successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      
      final isValid = await oktaProvider.verifyToken();
      expect(isValid, isTrue);
    });

    test('should refresh token successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      
      final newToken = await oktaProvider.refreshToken('mock-refresh-token');
      expect(newToken, isNotNull);
      expect(newToken, contains('refreshed_token_'));
    });

    test('should enable MFA successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      await oktaProvider.enableMFA('SMS');
      
      final user = await oktaProvider.getCurrentUser();
      expect(user.customAttributes?['mfaEnabled'], isTrue);
      expect(user.customAttributes?['mfaFactor'], equals('SMS'));
    });

    test('should disable MFA successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      await oktaProvider.enableMFA('SMS');
      await oktaProvider.disableMFA();
      
      final user = await oktaProvider.getCurrentUser();
      expect(user.customAttributes?['mfaEnabled'], isFalse);
    });

    test('should get user groups successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      
      final groups = await oktaProvider.getUserGroups('okta_test_example_com');
      expect(groups, contains('DefaultGroup'));
    });

    test('should assign user to group successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      await oktaProvider.assignUserToGroup('okta_test_example_com', 'AdminGroup');
      
      final groups = await oktaProvider.getUserGroups('okta_test_example_com');
      expect(groups, contains('AdminGroup'));
    });

    test('should remove user from group successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      await oktaProvider.assignUserToGroup('okta_test_example_com', 'AdminGroup');
      await oktaProvider.removeUserFromGroup('okta_test_example_com', 'AdminGroup');
      
      final groups = await oktaProvider.getUserGroups('okta_test_example_com');
      expect(groups, isNot(contains('AdminGroup')));
    });

    test('should reset password successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      // This should not throw an exception
      await oktaProvider.resetPassword('test@example.com');
    });

    test('should get audit logs successfully', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'test.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      await oktaProvider.signIn('test@example.com', 'password123');
      
      final logs = await oktaProvider.getAuditLogs('okta_test_example_com');
      expect(logs, isNotEmpty);
      expect(logs.first['event'], equals('user.authentication.auth'));
    });

    test('should throw exception when not initialized', () async {
      try {
        await oktaProvider.signIn('test@example.com', 'password123');
        fail('Expected signIn to throw');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}
