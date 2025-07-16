import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/okta/lib/ds_okta_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

void main() {
  group('Okta Auth Provider Integration Tests', () {
    late DSOktaAuthProvider oktaProvider;
    
    setUp(() {
      oktaProvider = DSOktaAuthProvider();
    });

    test('should complete full authentication workflow', () async {
      // Initialize
      await oktaProvider.initialize({
        'oktaDomain': 'dev-123456.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      // Create account
      await oktaProvider.createAccount('integration@example.com', 'password123',
          displayName: 'Integration User');

      // Sign in
      await oktaProvider.signIn('integration@example.com', 'password123');

      // Verify current user
      final currentUser = await oktaProvider.getCurrentUser();
      expect(currentUser.email, equals('integration@example.com'));
      expect(currentUser.displayName, equals('Integration User'));

      // Enable MFA
      await oktaProvider.enableMFA('SMS');
      final userWithMFA = await oktaProvider.getCurrentUser();
      expect(userWithMFA.customAttributes?['mfaEnabled'], isTrue);

      // Manage groups
      await oktaProvider.assignUserToGroup('okta_integration_example_com', 'AdminGroup');
      final groups = await oktaProvider.getUserGroups('okta_integration_example_com');
      expect(groups, contains('AdminGroup'));

      // Get audit logs
      final logs = await oktaProvider.getAuditLogs('okta_integration_example_com');
      expect(logs, isNotEmpty);

      // Sign out
      await oktaProvider.signOut();

      // Verify signed out
      try {
        await oktaProvider.getCurrentUser();
        fail('Expected getCurrentUser to throw after sign out');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should handle errors gracefully', () async {
      // Test without initialization
      try {
        await oktaProvider.signIn('test@example.com', 'password');
        fail('Expected error when not initialized');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('not initialized'));
      }

      // Initialize and test without signed in user
      await oktaProvider.initialize({
        'oktaDomain': 'dev-123456.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      try {
        await oktaProvider.getCurrentUser();
        fail('Expected error when no user signed in');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('No user'));
      }
    });

    test('should handle complex user management scenarios', () async {
      await oktaProvider.initialize({
        'oktaDomain': 'dev-123456.okta.com',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'redirectUri': 'https://example.com/callback',
      });

      // Create multiple users
      await oktaProvider.createAccount('user1@example.com', 'password123');
      await oktaProvider.createAccount('user2@example.com', 'password123');
      await oktaProvider.createAccount('admin@example.com', 'password123');

      // Test different users
      await oktaProvider.signIn('user1@example.com', 'password123');
      await oktaProvider.enableMFA('TOTP');
      await oktaProvider.signOut();

      await oktaProvider.signIn('admin@example.com', 'password123');
      await oktaProvider.assignUserToGroup('okta_admin_example_com', 'AdminGroup');
      await oktaProvider.assignUserToGroup('okta_admin_example_com', 'UserGroup');

      final adminGroups = await oktaProvider.getUserGroups('okta_admin_example_com');
      expect(adminGroups, contains('AdminGroup'));
      expect(adminGroups, contains('UserGroup'));

      // Test group removal
      await oktaProvider.removeUserFromGroup('okta_admin_example_com', 'UserGroup');
      final updatedGroups = await oktaProvider.getUserGroups('okta_admin_example_com');
      expect(updatedGroups, contains('AdminGroup'));
      expect(updatedGroups, isNot(contains('UserGroup')));
    });
  });
}
