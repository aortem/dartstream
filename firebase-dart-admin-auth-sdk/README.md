# Firebase Dart Admin Auth SDK

## Overview

The Firebase Dart Admin Auth SDK offers a robust and flexible set of tools to perform authentication procedures within Dart or Flutter projects. This is a Dart implementation of Firebase admin authentication.

## Features:

- **User Management:** Manage user accounts seamlessly with a suite of comprehensive user management functionalities.
- **Custom Token Minting:** Integrate Firebase authentication with your backend services by generating custom tokens.
- **Generating Email Action Links:** Perform authentication by creating and sending email action links to users emails for email verification, password reset, etc.
- **ID Token verification:** Verify ID tokens securely to ensure that application users are authenticated and authorised to use app.
- **Managing SAML/OIDC Provider Configuration**: Manage and configure SAML and ODIC providers to support authentication and simple sign-on solutions.

## Getting Started

If you want to use the Firebase Dart Admin Auth SDK for implementing a Firebase authentication in your Dart or Flutter projects follow the instructions on how to set up the auth SDK.

- Ensure you have a Flutter or Dart (3.4.x) SDK installed in your system.
- Set up a Firebase project and service account.
- Set up a Dart or Flutter project.

## Installation

For Dart use:

```bash
dart pub add firebase_dart_admin_auth_sdk
```

For Flutter use:

```javascript
flutter pub add firebase_dart_admin_auth_sdk
```

You can manually edit your `pubspec.yaml `file this:

```yaml
dependencies:
  firebase_dart_admin_auth_sdk: ^0.0.1-pre
```

You can run a `dart pub get` or `flutter pub get` for Dart and Flutter respectively to complete installation.

**NB:** SDK version might vary.

## Usage

**Example:**

```
   import 'dart:async';
   import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

   Future<void> main(List<String> arguments) async {
     // Replace 'path/to/serviceAccountKey.json' with your actual path
     final serviceAccountKeyFilePath = 'path/to/serviceAccountKey.json';

     // Initialize FirebaseAuth using service account with keys
     final auth = FirebaseAuth.fromServiceAccountWithKeys(
       serviceAccountKeyFilePath: serviceAccountKeyFilePath,
     );

     // Example: Sign in with email and password
     try {
       final userCredential = await auth.signInWithEmailAndPassword(
         'user@example.com',
         'password',
       );
       print('Signed in as ${userCredential.user?.email}');
     } catch (e) {
       print('Sign-in error: $e');
     }
   }
```

- Import the package into your Dart or Flutter project:

  ```
  import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
  ```

  \

- Save `serviceAccountKey.json` file path in a variable `serviceAccountKeyFilePath`.

  ```
  final serviceAccountKeyFilePath = 'path/to/serviceAccountKey.json';
  ```

  \

- Initialize FirebaseAuth using service account with keys:

  ```
  final auth = FirebaseAuth.fromServiceAccountWithKeys(serviceAccountKeyFilePath: serviceAccountKeyFilePath);
  ```

  \

- Use the `auth.signInWithEmailAndPassword()` to sign in an existing user or new user.

  ```
  final userCredential = await auth.signInWithEmailAndPassword('newuser@example.com', 'password123');
  ```

## Documentation

For more refer to Gitbook for prelease [documentation here](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk/).
