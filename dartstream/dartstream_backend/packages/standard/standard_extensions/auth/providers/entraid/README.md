# Microsoft EntraID (Azure AD B2C) Authentication Provider

A comprehensive authentication provider for DartStream that integrates with Microsoft EntraID (formerly Azure AD B2C). This provider supports consumer identity management, B2B scenarios, and enterprise authentication with user flows, custom policies, and multi-factor authentication.

## Features

- **User Registration & Authentication** - Create and authenticate users with Azure AD B2C
- **User Flows** - Pre-built authentication experiences (sign-up/sign-in, password reset, profile edit)
- **Custom Policies** - Advanced authentication scenarios with custom logic
- **Multi-Factor Authentication** - SMS, email, and authenticator app support
- **Social Identity Providers** - Google, Facebook, Twitter, LinkedIn, and 30+ others
- **Profile Management** - Update user profiles and custom attributes
- **Group Management** - Assign users to groups and manage permissions
- **Token Management** - JWT token validation, refresh, and claims processing
- **Audit Logging** - Comprehensive authentication audit trails
- **Error Handling** - Robust error handling with detailed error messages
- **Event System** - Extensible event hooks for authentication events

## Installation

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  # Base authentication package
  # ds_auth_base:
    path: path/to/auth/base
  
  # EntraID provider
  ds_entraid_auth_provider:
    path: path/to/auth/providers/entraid
```

## Quick Start

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_entraid_auth_provider/ds_entraid_auth_provider.dart';

// Create EntraID provider
final entraidProvider = DSEntraIDAuthProvider(
  tenantId: 'your-tenant-id',
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  userFlowName: 'B2C_1_signupsignin',
);

// Initialize the provider
await entraidProvider.initialize({
  'tenantId': 'your-tenant-id',
  'clientId': 'your-client-id',
  'clientSecret': 'your-client-secret',
  'userFlowName': 'B2C_1_signupsignin',
});

// Register with DartStream
DSAuthManager.registerProvider('entraid', entraidProvider);
final authManager = DSAuthManager('entraid');

// Use the authentication manager
await authManager.createAccount('user@example.com', 'password123');
await authManager.signIn('user@example.com', 'password123');
```

## Configuration

### Basic Configuration

```dart
final entraidProvider = DSEntraIDAuthProvider(
  tenantId: 'your-tenant-id',                    // Required: Azure AD B2C tenant ID
  clientId: 'your-client-id',                    // Required: Application client ID
  clientSecret: 'your-client-secret',            // Required: Application client secret
  userFlowName: 'B2C_1_signupsignin',           // Optional: Default user flow
  policyName: 'B2C_1_signupsignin',             // Optional: Policy name (alternative to userFlowName)
  domain: 'your-tenant.b2clogin.com',           // Optional: Custom domain
);
```

### Advanced Configuration

```dart
final entraidProvider = DSEntraIDAuthProvider(
  tenantId: 'your-tenant-id',
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  userFlowName: 'B2C_1_signupsignin',
  domain: 'your-tenant.b2clogin.com',
  securitySettings: {
    'requireMFA': true,
    'sessionTimeout': 3600,
    'maxLoginAttempts': 5,
  },
  customAttributes: {
    'Department': 'extension_Department',
    'JobTitle': 'extension_JobTitle',
    'Location': 'extension_Location',
  },
);
```

## Usage Examples

### Basic Authentication

```dart
// Create account
await authManager.createAccount(
  'user@company.com',
  'SecurePassword123!',
  displayName: 'John Doe',
);

// Sign in
await authManager.signIn('user@company.com', 'SecurePassword123!');

// Get current user
final user = await authManager.getCurrentUser();
print('Welcome ${user.displayName}!');

// Sign out
await authManager.signOut();
```

### User Flow Authentication

```dart
// Sign in with specific user flow
await entraidProvider.signInWithUserFlow(
  'user@company.com',
  'SecurePassword123!',
  userFlowName: 'B2C_1_signupsignin',
);

// Sign up with user flow
await entraidProvider.signUpWithUserFlow(
  'newuser@company.com',
  'SecurePassword123!',
  displayName: 'New User',
  userFlowName: 'B2C_1_signupsignin',
);

// Password reset flow
await entraidProvider.initiatePasswordResetFlow(
  'user@company.com',
  userFlowName: 'B2C_1_password_reset',
);

// Profile edit flow
await entraidProvider.initiateProfileEditFlow(
  userFlowName: 'B2C_1_profile_edit',
);
```

### Profile Management

```dart
// Update user profile
await entraidProvider.updateProfile(
  displayName: 'Jane Smith',
  photoURL: 'https://company.com/avatar.jpg',
);

// Update profile with custom attributes
await entraidProvider.updateProfile(
  displayName: 'Jane Smith',
  customAttributes: {
    'extension_Department': 'Engineering',
    'extension_JobTitle': 'Senior Developer',
    'extension_Location': 'Seattle',
  },
);

// Update email
await entraidProvider.updateEmail('newemail@company.com');

// Update password
await entraidProvider.updatePassword('NewSecurePassword123!');
```

### Multi-Factor Authentication

```dart
// Enable MFA
await entraidProvider.enableMFA(
  type: 'SMS',
  phoneNumber: '+1234567890',
);

// Disable MFA
await entraidProvider.disableMFA();

// Check MFA status
final mfaEnabled = await entraidProvider.isMFAEnabled();
```

### Group Management

```dart
// Get user groups
final groups = await entraidProvider.getUserGroups();

// Assign user to group
await entraidProvider.assignUserToGroup('admin_group');

// Remove user from group
await entraidProvider.removeUserFromGroup('default_group');
```

### Token Management

```dart
// Verify token
final isValid = await authManager.verifyToken();

// Refresh token
final newToken = await authManager.refreshToken('refresh_token');

// Get token claims
final user = await authManager.getCurrentUser();
final claims = user.customAttributes?['token_claims'] as Map<String, dynamic>?;
```

### Audit Logging

```dart
// Get audit logs
final logs = await entraidProvider.getAuditLogs(
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
);

// Process audit logs
for (final log in logs) {
  print('Event: ${log['event']}, User: ${log['user']}, Time: ${log['timestamp']}');
}
```

## Environment Variables

Set these environment variables for configuration:

```bash
# Azure AD B2C Configuration
ENTRAID_TENANT_ID=your-tenant-id
ENTRAID_CLIENT_ID=your-client-id
ENTRAID_CLIENT_SECRET=your-client-secret
ENTRAID_USER_FLOW_NAME=B2C_1_signupsignin
ENTRAID_POLICY_NAME=B2C_1_signupsignin
ENTRAID_DOMAIN=your-tenant.b2clogin.com

# Optional: Custom domain and settings
ENTRAID_CUSTOM_DOMAIN=login.company.com
ENTRAID_SCOPE=openid profile email offline_access
```

## Azure AD B2C Setup

### 1. Create Azure AD B2C Tenant

1. Go to [Azure Portal](https://portal.azure.com)
2. Create a new Azure AD B2C tenant
3. Configure the tenant settings
4. Note the tenant ID

### 2. Register Application

1. In the Azure AD B2C portal, go to App registrations
2. Create a new registration
3. Configure redirect URIs
4. Generate client secret
5. Note the client ID and secret

### 3. Create User Flows

1. Go to User flows in the Azure AD B2C portal
2. Create sign-up/sign-in flow: `B2C_1_signupsignin`
3. Create password reset flow: `B2C_1_password_reset`
4. Create profile edit flow: `B2C_1_profile_edit`
5. Configure attributes and claims

### 4. Configure Identity Providers (Optional)

1. Go to Identity providers
2. Add social identity providers (Google, Facebook, etc.)
3. Configure OAuth settings
4. Update user flows to include social providers

## Error Handling

The provider includes comprehensive error handling:

```dart
try {
  await authManager.signIn('user@example.com', 'password');
} on DSAuthError catch (e) {
  switch (e.code) {
    case 'invalid_credentials':
      print('Invalid email or password');
      break;
    case 'user_not_found':
      print('User account not found');
      break;
    case 'account_disabled':
      print('User account is disabled');
      break;
    default:
      print('Authentication failed: ${e.message}');
  }
}
```

## Event Hooks

Configure event hooks for authentication events:

```dart
// Login success hook
entraidProvider.onLoginSuccess = (user) async {
  print('User logged in: ${user.email}');
  // Custom logic here
};

// Logout hook
entraidProvider.onLogout = () async {
  print('User logged out');
  // Custom logic here
};

// User flow completion hook
entraidProvider.onUserFlowComplete = (flowName, user) async {
  print('User flow $flowName completed for ${user.email}');
  // Custom logic here
};

// Password reset hook
entraidProvider.onPasswordReset = (email) async {
  print('Password reset requested for $email');
  // Custom logic here
};
```

## Testing

The provider includes comprehensive test coverage:

```bash
# Run all tests
dart test

# Run specific test files
dart test test/ds_entraid_auth_provider_test.dart
dart test test/ds_entraid_auth_comprehensive_test.dart
dart test test/ds_entraid_auth_standalone_test.dart
```

## License

This provider is licensed under the BSD-3-Clause license. See the LICENSE file for details.

## Support

For support and questions:

- [DartStream Documentation](https://docs.dartstream.dev)
- [GitHub Issues](https://github.com/dartstream/dartstream/issues)
- [Community Forum](https://community.dartstream.dev)

## Contributing

Contributions are welcome! Please read the contributing guidelines and submit pull requests to the main repository.
