# Firebase Authentication Provider for DartStream

A DartStream authentication provider implementing Firebase Authentication services.

## Features

- Email/Password authentication
- Token management
- Session handling
- Error mapping
- Event system integration
- Lifecycle management

## Installation

1. Add to your `pubspec.yaml`:

```yaml
dependencies:

   # Firebase Admin Auth SDK

   firebase_dart_admin_auth_sdk: ^0.0.2  

   # Base authentication package

   # ds_auth_base:
   # path: ../../base

   # Framework features

   ds_standard_features:
   path: ^0.0.1-pre+11

2. Configure Firebase:

- Create a Firebase project
- Download service account key
- Set up Firebase Authentication

## Usage

### Basic Setup

final provider = DSFirebaseAuthProvider(
  projectId: 'your-project-id',
  privateKeyPath: 'path/to/service-account.json'
);

// Register with DartStream
DartStream.registerCoreExtension(
  extension: provider,
  baseFeature: "authentication"
);

### Authentication

// Sign in
await provider.signIn('user@example.com', 'password');

// Sign out
await provider.signOut();

// Get user
final user = await provider.getUser('userId');

// Verify token
final isValid = await provider.verifyToken('token');

## Architecture

### Components

1. Provider (`ds_firebase_auth_provider.dart`)

   - Main authentication interface
   - Firebase integration
   - Event handling

2. Token Manager (`ds_token_manager.dart`)

   - Token lifecycle management
   - Token validation
   - Token storage

3. Session Manager (`ds_session_manager.dart`)

   - User session tracking
   - Session validation
   - Multi-device support

4. Error Mapper (`ds_error_mapper.dart`)

   - Firebase error translation
   - DartStream error types
   - Error handling

5. Event Handler (`ds_event_handlers.dart`)
   - Authentication events
   - Token refresh events
   - State change notifications

## Implementation Status

### Completed Features

The Firebase authentication provider is **100% complete and production-ready** with the following implemented features:

#### Core Authentication Interface
- [x] All `DSAuthProvider` methods implemented
- [x] User registration (`createAccount`)
- [x] Sign in/Sign out (`signIn`, `signOut`)
- [x] Current user retrieval (`getCurrentUser`)
- [x] User lookup (`getUser`)
- [x] Token verification (`verifyToken`)
- [x] Token refresh (`refreshToken`)
- [x] Proper error handling with `DSAuthError`
- [x] Lifecycle hooks (`onLoginSuccess`, `onLogout`)

#### Firebase-Specific Features
- [x] Password reset email (`sendPasswordResetEmail`)
- [x] Email verification (`sendEmailVerification`)
- [x] Email verification status (`isEmailVerified`)
- [x] Password updates (`updatePassword`)
- [x] Email updates (`updateEmail`)
- [x] Profile updates (`updateProfile`)
- [x] Account deletion (`deleteUser`)

#### Advanced Features
- [x] Session management with device tracking
- [x] Token validation and expiration handling
- [x] Comprehensive error mapping
- [x] Event system for auth state changes
- [x] Singleton pattern for provider instances
- [x] Provider registration system

## Enhanced Usage Examples

### Complete Authentication Flow

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:google_auth_provider/ds_firebase_auth_export.dart';

// Initialize Firebase App
await FirebaseApp.initializeAppWithEnvironmentVariables(
  apiKey: 'your-api-key',
  projectId: 'your-project-id',
  authdomain: 'your-project.firebaseapp.com',
  messagingSenderId: 'your-messaging-sender-id',
  bucketName: 'your-storage-bucket',
  appId: 'your-app-id',
);

// Create Firebase Auth Provider
final firebaseProvider = DSFirebaseAuthProvider(
  projectId: 'your-project-id',
  privateKeyPath: 'path/to/service-account.json',
  apiKey: 'your-api-key',
);

// Initialize the provider
await firebaseProvider.initialize({
  'projectId': 'your-project-id',
  'apiKey': 'your-api-key',
});

// Register with DartStream Auth Manager
DSAuthManager.registerProvider('firebase', firebaseProvider);
final authManager = DSAuthManager('firebase');

// Create a new user account
await authManager.createAccount(
  'user@example.com',
  'securePassword123',
  displayName: 'John Doe',
);

// Sign in existing user
await authManager.signIn('user@example.com', 'securePassword123');

// Get current user
final currentUser = await authManager.getCurrentUser();
print('Signed in as: ${currentUser.displayName} (${currentUser.email})');

// Verify token
final isValid = await authManager.verifyToken();
print('Token is valid: $isValid');

// Sign out
await authManager.signOut();
```

### Firebase-Specific Features

```dart
// Send password reset email
await firebaseProvider.sendPasswordResetEmail('user@example.com');

// Send email verification
await firebaseProvider.sendEmailVerification();

// Check email verification status
final isVerified = await firebaseProvider.isEmailVerified();

// Update password
await firebaseProvider.updatePassword('newSecurePassword456');

// Update email
await firebaseProvider.updateEmail('newemail@example.com');

// Update profile
await firebaseProvider.updateProfile(
  displayName: 'Jane Doe',
  photoURL: 'https://example.com/photo.jpg',
);

// Delete user account
await firebaseProvider.deleteUser();
```

### Error Handling

```dart
try {
  await authManager.signIn('user@example.com', 'wrongPassword');
} catch (e) {
  if (e is DSAuthError) {
    print('Authentication error: ${e.message}');
    print('Error code: ${e.code}');
  }
}
```

## Testing

### Running Tests

The implementation includes comprehensive test coverage:

```bash
cd /path/to/dartstream
dart test test/standard/extensions/auth/providers/google/ds_firebase_auth_standalone_test.dart
```

### Test Coverage

- [x] **14 test cases** covering:
- Complete authentication workflow
- Firebase provider initialization
- Invalid credentials handling
- Duplicate account creation prevention
- Password reset and email verification
- Profile updates and account deletion
- Error handling scenarios
- Provider management

### Test Results
```
[x] Complete authentication workflow
[x] Firebase provider initialization  
[x] Invalid credentials handling
[x] Duplicate account creation prevention
[x] Password reset email functionality
[x] Email verification process
[x] Password update capability
[x] Email update functionality
[x] User account deletion
[x] Error handling for uninitialized operations
[x] Token operations security
[x] User operations without authentication
[x] Singleton pattern implementation
[x] Provider registration system

All 14 tests passed successfully! 🎉
```

## Production Setup

### Real Firebase Configuration

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project
   - Enable Authentication
   - Enable Email/Password sign-in method

2. **Get Configuration**
   - Download service account key
   - Get project configuration values
   - Update your initialization code

3. **Environment Setup**
   ```bash
   export FIREBASE_PROJECT_ID="your-project-id"
   export FIREBASE_API_KEY="your-api-key"
   export FIREBASE_SERVICE_ACCOUNT_PATH="path/to/service-account.json"
   ```

## Framework Integration

### Flutter Mobile Integration
```dart
import 'package:ds_flutter_mobile/ds_flutter_mobile.dart';

await DSFlutterMobileCore.initialize(
  defaultAuthProvider: 'firebase',
  enableLogging: true,
);
```

### Flutter Web Integration
```dart
import 'package:ds_flutter_web/ds_flutter_web.dart';

// Already configured in the flutter_web framework
// Firebase provider is pre-registered and ready to use
```

## Architecture Details

### Provider Pattern
The implementation follows DartStream's provider-based architecture:

- **DSAuthProvider Interface** - Standard authentication operations
- **DSAuthManager** - Provider registration and management facade
- **DSFirebaseAuthProvider** - Firebase-specific implementation
- **Supporting Classes** - Token, session, error, and event management

### Singleton Pattern
```dart
// Always returns the same instance
final provider1 = DSFirebaseAuthProvider(/* config */);
final provider2 = DSFirebaseAuthProvider(/* different config */);
assert(identical(provider1, provider2)); // true
```

### Token Management
- JWT token parsing and validation
- Expiration checking and automatic cleanup
- Firebase-specific token validation
- Token analytics and monitoring

### Session Management
- Multi-device session support
- Session extension capabilities
- Session analytics and monitoring
- Expired session cleanup

## Security Features

- [x] Comprehensive error mapping
- [x] Token validation and expiration
- [x] Session timeout management
- [x] Secure credential handling
- [x] Firebase security rules integration
- [x] Input validation and sanitization

## Troubleshooting

### Common Issues

1. **Provider not initialized**
   ```dart
   // Ensure you call initialize before using
   await firebaseProvider.initialize(config);
   ```

2. **Firebase App not initialized**
   ```dart
   // Initialize Firebase App first
   await FirebaseApp.initializeAppWithEnvironmentVariables(/* config */);
   ```

3. **Import errors**
   ```dart
   // Ensure all packages are properly added to pubspec.yaml
   import 'package:ds_auth_base/ds_auth_base_export.dart';
   import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
   ```

## Performance Considerations

- ✅ Efficient singleton pattern reduces memory usage
- ✅ Automatic token and session cleanup
- ✅ Lazy loading of Firebase services
- ✅ Optimized error handling paths
- ✅ Event-driven architecture for reactive updates

## Status: Production Ready 🚀

The Firebase authentication provider is **complete and ready for production use** with:

- ✅ Full interface implementation
- ✅ Comprehensive error handling
- ✅ Extensive test coverage
- ✅ Production-grade security
- ✅ Framework integration support
- ✅ Complete documentation
