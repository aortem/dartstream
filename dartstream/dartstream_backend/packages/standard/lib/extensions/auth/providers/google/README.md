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

   firebase_dart_admin_auth_sdk: ^0.0.1-pre+10

   # Base authentication package

   ds_auth_base:
   path: ../../base

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
```
