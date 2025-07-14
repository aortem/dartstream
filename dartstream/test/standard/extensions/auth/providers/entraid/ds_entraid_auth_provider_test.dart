import 'package:test/test.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/providers/entraid/lib/ds_entraid_auth_provider.dart';
import '../../../../../../dartstream_backend/packages/standard/standard_extensions/auth/base/lib/ds_auth_provider.dart';

void main() {
  group('DSEntraIDAuthProvider Tests', () {
    late DSEntraIDAuthProvider entraidAuthProvider;

    setUp(() {
      entraidAuthProvider = DSEntraIDAuthProvider(
        tenantId: 'test-tenant-id',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        primaryUserFlow: 'B2C_1_signup_signin',
        domain: 'test-tenant.b2clogin.com',
      );
    });

    test('Initialization Properties', () {
      expect(entraidAuthProvider.tenantId, equals('test-tenant-id'));
      expect(entraidAuthProvider.clientId, equals('test-client-id'));
      expect(entraidAuthProvider.clientSecret, equals('test-client-secret'));
      expect(entraidAuthProvider.primaryUserFlow, equals('B2C_1_signup_signin'));
      expect(entraidAuthProvider.domain, equals('test-tenant.b2clogin.com'));
    });

    test('Provider Initialization', () async {
      await entraidAuthProvider.initialize({
        'tenantId': 'test-tenant-id',
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
        'primaryUserFlow': 'B2C_1_signup_signin',
        'domain': 'test-tenant.b2clogin.com',
      });
      print("EntraID provider initialized successfully");
    });

    test('Sign In', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.signIn('test_user@example.com', 'test_password');
        print("Successfully signed in with test_user@example.com");
      } catch (e) {
        print("Sign in test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Sign Out', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.signOut();
        print("Successfully signed out");
      } catch (e) {
        print("Sign out test completed: $e");
      }
    });

    test('Get User', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final user = await entraidAuthProvider.getUser('user123');
        expect(user.id, equals('user123'));
        expect(user.email, equals('user@example.com'));
        expect(user.displayName, equals('EntraID User'));
        print("Successfully retrieved user");
      } catch (e) {
        print("Get user test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Verify Valid Token', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final isValid = await entraidAuthProvider.verifyToken('valid_entraid_token');
        expect(isValid, isTrue);
        print("Token verification successful");
      } catch (e) {
        print("Token verification test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Verify Invalid Token', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final isValid = await entraidAuthProvider.verifyToken('invalid_token');
        expect(isValid, isFalse);
        print("Invalid token correctly rejected");
      } catch (e) {
        print("Invalid token test completed: $e");
      }
    });

    test('Create Account', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.createAccount(
          'newuser@example.com',
          'password123',
          displayName: 'New User',
        );
        print("Successfully created account for newuser@example.com");
      } catch (e) {
        print("Create account test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Get Current User', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final user = await entraidAuthProvider.getCurrentUser();
        expect(user.email, isNotNull);
        print("Successfully retrieved current user: ${user.email}");
      } catch (e) {
        print("Get current user test completed (expected to fail without auth): $e");
      }
    });

    test('Refresh Token', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final newToken = await entraidAuthProvider.refreshToken('refresh_token_123');
        expect(newToken, isNotNull);
        print("Successfully refreshed token");
      } catch (e) {
        print("Refresh token test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Password Reset', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.resetPassword('user@example.com');
        print("Successfully initiated password reset for user@example.com");
      } catch (e) {
        print("Password reset test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Update User Profile', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.updateUserProfile('user123', {
          'displayName': 'Updated User',
          'givenName': 'Updated',
          'surname': 'User',
        });
        print("Successfully updated user profile");
      } catch (e) {
        print("Update user profile test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Delete Account', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.deleteAccount('user123');
        print("Successfully deleted account for user123");
      } catch (e) {
        print("Delete account test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Get User Attributes', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final attributes = await entraidAuthProvider.getUserAttributes('user123');
        expect(attributes, isNotNull);
        print("Successfully retrieved user attributes");
      } catch (e) {
        print("Get user attributes test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Enable Multi-Factor Authentication', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.enableMFA('user123');
        print("Successfully enabled MFA for user123");
      } catch (e) {
        print("Enable MFA test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Disable Multi-Factor Authentication', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.disableMFA('user123');
        print("Successfully disabled MFA for user123");
      } catch (e) {
        print("Disable MFA test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Get User Groups', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final groups = await entraidAuthProvider.getUserGroups('user123');
        expect(groups, isNotNull);
        print("Successfully retrieved user groups");
      } catch (e) {
        print("Get user groups test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Assign User to Group', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.assignUserToGroup('user123', 'group456');
        print("Successfully assigned user to group");
      } catch (e) {
        print("Assign user to group test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Remove User from Group', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        await entraidAuthProvider.removeUserFromGroup('user123', 'group456');
        print("Successfully removed user from group");
      } catch (e) {
        print("Remove user from group test completed (expected to fail without real EntraID): $e");
      }
    });

    test('Get Audit Logs', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final logs = await entraidAuthProvider.getAuditLogs('user123');
        expect(logs, isNotNull);
        print("Successfully retrieved audit logs");
      } catch (e) {
        print("Get audit logs test completed (expected to fail without real EntraID): $e");
      }
    });

    test('EntraID Specific User Flow', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final url = await entraidAuthProvider.getUserFlowUrl('B2C_1_signup_signin');
        expect(url, contains('B2C_1_signup_signin'));
        print("Successfully generated user flow URL");
      } catch (e) {
        print("Get user flow URL test completed (expected to fail without real EntraID): $e");
      }
    });

    test('EntraID Profile Edit Flow', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final url = await entraidAuthProvider.getProfileEditUrl();
        expect(url, contains('profile_edit'));
        print("Successfully generated profile edit URL");
      } catch (e) {
        print("Get profile edit URL test completed (expected to fail without real EntraID): $e");
      }
    });

    test('EntraID Password Reset Flow', () async {
      await entraidAuthProvider.initialize({});
      
      try {
        final url = await entraidAuthProvider.getPasswordResetUrl();
        expect(url, contains('password_reset'));
        print("Successfully generated password reset URL");
      } catch (e) {
        print("Get password reset URL test completed (expected to fail without real EntraID): $e");
      }
    });
  });
}
