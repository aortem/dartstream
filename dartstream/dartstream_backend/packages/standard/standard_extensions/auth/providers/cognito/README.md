# DartStream Cognito Authentication Provider

A comprehensive AWS Cognito authentication provider for the DartStream framework. This package provides seamless integration with AWS Cognito User Pools for secure user authentication and management.

## Features

- ✅ **Complete DSAuthProvider Implementation** - Full feature parity with other DartStream auth providers
- ✅ **User Authentication** - Sign up, sign in, and sign out with email/password
- ✅ **Email Verification** - Confirm user email addresses with verification codes
- ✅ **Password Management** - Reset forgotten passwords and update existing passwords
- ✅ **Profile Management** - Update user profiles, emails, and custom attributes
- ✅ **Token Management** - JWT token validation, refresh, and session management
- ✅ **User Management** - Retrieve user information and delete user accounts
- ✅ **Error Handling** - Comprehensive error mapping and handling
- ✅ **Event System** - Authentication lifecycle hooks and event handling
- ✅ **Session Management** - Secure session storage and management
- ✅ **Mock Support** - Testing utilities for development and testing

## Installation

Add the Cognito provider to your `pubspec.yaml`:

```yaml
dependencies:
  # ds_auth_base:
    path: ../auth/base
  ds_cognito_auth_provider:
    path: ../auth/providers/cognito
```

## Quick Start

### Basic Setup

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_cognito_auth_provider/ds_cognito_auth_export.dart';

// Create and initialize the provider
final cognitoProvider = DSCognitoAuthProvider(
  userPoolId: 'us-east-1_abc123def',
  clientId: 'your-cognito-client-id',
  region: 'us-east-1',
  clientSecret: 'your-client-secret', // Optional
);

await cognitoProvider.initialize({
  'userPoolId': 'us-east-1_abc123def',
  'clientId': 'your-cognito-client-id',
  'region': 'us-east-1',
});

// Register with DartStream
DSAuthManager.registerProvider('cognito', cognitoProvider);
final authManager = DSAuthManager('cognito');
```

### Environment Configuration

```bash
# AWS Cognito Configuration
COGNITO_USER_POOL_ID=us-east-1_abc123def
COGNITO_CLIENT_ID=your-cognito-client-id
COGNITO_CLIENT_SECRET=your-client-secret
COGNITO_REGION=us-east-1
```

### Basic Authentication Flow

```dart
// Create account
await authManager.createAccount(
  'user@example.com',
  'SecurePassword123!',
  displayName: 'John Doe',
);

// Confirm email
await cognitoProvider.confirmEmail('user@example.com', '123456');

// Sign in
await authManager.signIn('user@example.com', 'SecurePassword123!');

// Get current user
final user = await authManager.getCurrentUser();
print('Welcome ${user.displayName}!');

// Sign out
await authManager.signOut();
```

## API Reference

### DSCognitoAuthProvider

The main authentication provider class implementing the `DSAuthProvider` interface.

#### Constructor

```dart
DSCognitoAuthProvider({
  required String userPoolId,
  required String clientId,
  required String region,
  String? clientSecret,
  String? identityPoolId,
  Map<String, String>? customAttributes,
})
```

#### Core Methods

```dart
// Authentication
Future<void> signIn(String email, String password);
Future<void> signOut();
Future<void> createAccount(String email, String password, {String? displayName});

// User Management
Future<DSUser> getCurrentUser();
Future<DSUser> getUser(String userId);
Future<void> deleteUser();

// Token Management
Future<bool> verifyToken([String? token]);
Future<String> refreshToken(String refreshToken);

// Profile Management
Future<void> updateProfile({String? displayName, String? photoURL});
Future<void> updateEmail(String newEmail);
Future<void> sendEmailVerification();
Future<bool> isEmailVerified();

// Password Management
Future<void> sendPasswordResetEmail(String email);
Future<void> updatePassword(String newPassword);

// Cognito-Specific Methods
Future<void> confirmEmail(String email, String confirmationCode);
Future<void> updateUserAttributes(Map<String, String> attributes);
```

#### Event Handlers

```dart
// Set up event handlers
cognitoProvider.onLoginSuccess = (user) async {
  print('User logged in: ${user.email}');
};

cognitoProvider.onLogout = () async {
  print('User logged out');
};

cognitoProvider.onTokenRefresh = (token) async {
  print('Token refreshed: $token');
};
```

### Supporting Classes

#### DSTokenManager

Manages JWT tokens and validation.

```dart
final tokenManager = DSTokenManager();
await tokenManager.storeToken(token);
final isValid = await tokenManager.validateToken(token);
```

#### DSSessionManager

Handles user session storage and management.

```dart
final sessionManager = DSSessionManager();
await sessionManager.storeSession(user);
final session = await sessionManager.getSession();
```

#### DSErrorMapper

Maps AWS Cognito errors to DartStream error types.

```dart
final errorMapper = DSErrorMapper();
final dsError = errorMapper.mapError(cognitoException);
```

#### DSEventHandlers

Manages authentication lifecycle events.

```dart
final eventHandlers = DSEventHandlers();
eventHandlers.onEvent('login_success', (data) {
  print('Login successful: $data');
});
```

## Testing

### Running Tests

```bash
# Run all Cognito tests
dart test test/standard/extensions/auth/providers/cognito/

# Run specific test suites
dart test test/standard/extensions/auth/providers/cognito/ds_cognito_auth_provider_test.dart
dart test test/standard/extensions/auth/providers/cognito/ds_cognito_auth_comprehensive_test.dart
dart test test/standard/extensions/auth/providers/cognito/ds_cognito_auth_standalone_test.dart
```

### Mock Provider

For testing and development, use the mock provider:

```dart
final mockProvider = DSCognitoAuthProvider.createMockProvider();
await mockProvider.initialize({});

// Mock provider provides realistic responses without AWS API calls
DSAuthManager.registerProvider('cognito', mockProvider);
```

## AWS Cognito Setup

### Creating a User Pool

```bash
# Create User Pool
aws cognito-idp create-user-pool \
  --pool-name "dartstream-users" \
  --policies PasswordPolicy='{MinimumLength=8,RequireUppercase=true,RequireLowercase=true,RequireNumbers=true,RequireSymbols=true}' \
  --auto-verified-attributes email \
  --username-attributes email

# Create User Pool Client
aws cognito-idp create-user-pool-client \
  --user-pool-id us-east-1_abc123def \
  --client-name "dartstream-client" \
  --generate-secret \
  --explicit-auth-flows ADMIN_NO_SRP_AUTH USER_PASSWORD_AUTH
```

### User Pool Configuration

```bash
# Configure verification
aws cognito-idp update-user-pool \
  --user-pool-id us-east-1_abc123def \
  --verification-message-template \
  'EmailMessage="Please verify your email with code {####}",EmailSubject="Verify your email"'

# Configure password policy
aws cognito-idp update-user-pool \
  --user-pool-id us-east-1_abc123def \
  --policies PasswordPolicy='{MinimumLength=12,RequireUppercase=true,RequireLowercase=true,RequireNumbers=true,RequireSymbols=true}'
```

## Production Considerations

### Security Best Practices

1. **Use HTTPS Only** - Never send credentials over HTTP
2. **Validate Input** - Always validate user input on both client and server
3. **Enable MFA** - Multi-factor authentication for sensitive operations
4. **Monitor Failed Attempts** - Track and handle authentication failures
5. **Use Short-lived Tokens** - Implement proper token refresh cycles

### Performance Optimization

1. **Cache Tokens** - Cache valid tokens to reduce API calls
2. **Connection Pooling** - Use connection pooling for AWS API calls
3. **Batch Operations** - Batch user operations when possible
4. **Regional Deployment** - Deploy in regions close to your users

### Error Handling

```dart
try {
  await authManager.signIn(email, password);
} on DSAuthError catch (e) {
  switch (e.code) {
    case 'user_not_found':
      print('User not found');
      break;
    case 'invalid_password':
      print('Invalid password');
      break;
    case 'user_not_confirmed':
      print('Email not confirmed');
      break;
    default:
      print('Authentication error: ${e.message}');
  }
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This package is part of the DartStream project and is licensed under the BSD-3 License.

## Support

For issues, questions, or contributions, please visit the [DartStream GitHub repository](https://github.com/aortem/dartstream-opensource).
