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

If you want to use the Firebase Dart Admin Auth SDK for implementing a Firebase authentication in your Flutter projects follow the instructions on how to set up the auth SDK.

- Ensure you have a Flutter or Dart (3.4.x) SDK installed in your system.
- Set up a Firebase project and service account.
- Set up a Flutter project.

## Installation

For Flutter use:

```javascript
flutter pub add firebase_dart_admin_auth_sdk
```

You can manually edit your `pubspec.yaml `file this:

```yaml
dependencies:
  firebase_dart_admin_auth_sdk: ^0.0.1-pre+4
```

You can run a `flutter pub get` for Flutter respectively to complete installation.

**NB:** SDK version might vary.

## Usage

**Example:**

```
   import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
   import 'package:flutter/services.dart' show rootBundle;
   
   
   void main() async {
      //To initialize with service account put the path to the json file in the function below
      String serviceAccountContent = await rootBundle.loadString(
          'assets/service_account.json'); //Add your own JSON service account
     
     // Initialize Firebase with the service account content
      await FirebaseApp.initializeAppWithServiceAccount(
        serviceAccountContent: serviceAccountContent,
        serviceAccountKeyFilePath: '',
      );
      
      // Get Firebase auth instance for this project
      FirebaseApp.instance.getAuth();

     // Example: Sign in with email and password
     try {
       final user = await FirebaseApp.firebaseAuth
        ?.createUserWithEmailAndPassword('user005@gmail.com', 'password');
        
       final await userCredential = await FirebaseApp.firebaseAuth
       ?.signInWithEmailAndPassword('user005@gmail.com', 'password'); 
       
       print('Signed in as ${userCredential?.user.email}');
     } catch (e) {
       print('Sign-in error: $e');
     }
   }

```

- Import the package into your Dart or Flutter project:

  ```
  import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
  ```

- Save `serviceAccountKey.json` file path in a variable `serviceAccountKeyFilePath`.

  ```
  final serviceAccountKeyFilePath = 'path/to/serviceAccountKey.json';
  ```

- Initialize FirebaseAuth using service account with keys:

  ```
  final auth = FirebaseAuth.fromServiceAccountWithKeys(serviceAccountKeyFilePath: serviceAccountKeyFilePath);
  ```

- Use the `FirebaseApp.firebaseAuth?.signInWithEmailAndPassword()` to sign in an existing user or new user.

  ```
  final await userCredential = await FirebaseApp.firebaseAuth
      ?.signInWithEmailAndPassword('user005@gmail.com', 'password');
  ```

## Documentation

For more refer to Gitbook for prelease [documentation here](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk/).
