# Firebase Dart Admin Auth SDK

## Overview

The Firebase Dart Admin Auth SDK offers a robust and flexible set of tools to perform authentication procedures within Dart or Flutter projects. This is a Dart implementation of Firebase admin authentication.

## Features:

* **User Management:** Manage user accounts seamlessly with a suite of comprehensive user management functionalities.
* **Custom Token Minting:** Integrate Firebase authentication with your backend services by generating custom tokens.
* **Generating Email Action Links:** Perform authentication by creating and sending email action links to users emails for email verification, password reset, etc.
* **ID Token verification:** Verify ID tokens securely to ensure that application users are authenticated and authorised to use app.
* **Managing SAML/OIDC Provider Configuration**: Manage and configure SAML and ODIC providers to support authentication and simple sign-on solutions.

## Getting Started

If you want to use the Firebase Dart Admin Auth SDK for implementing a Firebase authentication in your Dart or Flutter projects follow the instructions on how to set up the auth SDK.

* Ensure you have a Flutter or Dart (3.4.x) SDK installed in your system.
* Set up a Firebase project and service account.
* Set up a Dart or Flutter project.

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

## Usage

**Example:**

```
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

void main() async {
  final auth =
      FirebaseAuth(apiKey: 'YOUR_API_KEY', projectId: 'YOUR_PROJECT_ID');

  try {
    // Sign up a new user
    final newUser = await auth.createUserWithEmailAndPassword(
        'newuser@example.com', 'password123');
    print('User created: ${newUser.user.email}');

    // Sign in with the new user
    final userCredential = await auth.signInWithEmailAndPassword(
        'newuser@example.com', 'password123');
    print('Signed in: ${userCredential.user.email}');
  } catch (e) {
    print('Error: $e');
  }
}
```


* Import the package into your Dart or Flutter project:

  ```
  import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
  ```

  \
* Initialize the package with your Firebase API key and project ID:

  ```
  final auth = FirebaseAuth(apiKey: 'YOUR_API_KEY', projectId: 'YOUR_PROJECT_ID');
  ```

  \
* Ensure you have a user email and password or create new user with email and password.

  ```
  final newUser = await auth.createUserWithEmailAndPassword('newuser@example.com', 'password123');
  ```

  A new user `newUser` is created in the above code snippet. Use the new user’s email address and password to sign them in.

  \
* Use the `auth.signInWithEmailAndPassword()` to sign in an existing user or new user.

  ```
  final userCredential = await auth.signInWithEmailAndPassword('newuser@example.com', 'password123');
  ```


## Documentation

For more refer to Gitbook for prelease [documentation here](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk/).



### Firebase Service Account Initialization
Sure, here's a detailed documentation on how users can use your package `firebase_dart_admin_auth_sdk` to connect to Firebase in a Flutter project, including steps to create a project in the Firebase Console.

---

## firebase_dart_admin_auth_sdk Documentation

### Overview

The `firebase_dart_admin_auth_sdk` package provides a way for Flutter developers to connect to Firebase using three different methods: service account with keys, environment variables, and service account without key impersonation. This package focuses on Firebase authentication, allowing developers to easily integrate Firebase Auth features into their Flutter projects.

### Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  firebase_dart_admin_auth_sdk: ^0.0.1-pre
  ds_standard_features: ^0.0.1-pre+7 
```

Run `flutter pub get` to install the package.

### Usage

#### Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click on "Add project" and follow the setup flow.
3. Once the project is created, click on the project to enter the project overview page.

#### Step 2: Add a Flutter App to the Firebase Project

1. In the Firebase Console, click on the "Settings" icon next to "Project Overview".
2. Select "Project settings".
3. Click on the "General" tab.
4. In the "Your apps" section, click on the Flutter icon to add a new Flutter app.
5. Follow the instructions to register your app with Firebase.

#### Step 3: Obtain Firebase Configuration

##### Method 1: Service Account with Keys

1. In the Firebase Console, go to "Project settings".
2. Select the "Service accounts" tab.
3. Click on "Generate new private key" and download the JSON file.
4. Place the JSON file in your project's root directory.

##### Method 2: Environment Variables

1. Go to "Project settings".
2. Copy the `apiKey` and `projectId` from the Firebase configuration.
3. Set the environment variables in your development environment.

##### Method 3: Service Account Without Key Impersonation

1. In the Firebase Console, go to "IAM & Admin".
2. Click on "Service accounts".
3. Create a new service account and configure the necessary roles.
4. Use the service account email and user email for authentication.

#### Step 4: Initialize FirebaseAuth

```dart
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:http/http.dart' as http;

void main() {
  // Initialize FirebaseAuth using one of the following methods

  // Method 1: Service Account with Keys
  final auth1 = FirebaseAuth.fromServiceAccountWithKeys(
    serviceAccountKeyFilePath: 'path/to/your/serviceAccountKey.json',
  );

  // Method 2: Environment Variables
  final auth2 = FirebaseAuth.fromEnvironmentVariables(
    apiKeyEnvVar: 'FIREBASE_API_KEY',
    projectIdEnvVar: 'FIREBASE_PROJECT_ID',
  );

  // Method 3: Service Account Without Key Impersonation
  final auth3 = FirebaseAuth.fromServiceAccountWithoutKeyImpersonation(
    serviceAccountEmail: 'your-service-account-email@your-project-id.iam.gserviceaccount.com',
    userEmail: 'your-user-email@example.com',
  );

  // Use the auth instance to perform Firebase operations
}
```

#### Step 5: Perform Firebase Auth Operations

```dart
void performAuthOperations(FirebaseAuth auth) async {
  // Sign in with email and password
  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      'email@example.com',
      'your-password',
    );
    print('User signed in: ${userCredential.user}');
  } catch (e) {
    print('Sign-in failed: $e');
  }

  // Sign out
  try {
    await auth.signOut();
    print('User signed out');
  } catch (e) {
    print('Sign-out failed: $e');
  }
}
```

### Full Example

```dart
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Initialize FirebaseAuth using one of the methods
  final FirebaseAuth auth = FirebaseAuth.fromServiceAccountWithKeys(
    serviceAccountKeyFilePath: 'path/to/your/serviceAccountKey.json',
  );

  // Alternatively, use environment variables
  // final FirebaseAuth auth = FirebaseAuth.fromEnvironmentVariables(
  //   apiKeyEnvVar: 'FIREBASE_API_KEY',
  //   projectIdEnvVar: 'FIREBASE_PROJECT_ID',
  // );

  // Alternatively, use service account without key impersonation
  // final FirebaseAuth auth = FirebaseAuth.fromServiceAccountWithoutKeyImpersonation(
  //   serviceAccountEmail: 'your-service-account-email@your-project-id.iam.gserviceaccount.com',
  //   userEmail: 'your-user-email@example.com',
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Auth SDK Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential = await auth.signInWithEmailAndPassword(
                  'email@example.com',
                  'your-password',
                );
                print('User signed in: ${userCredential.user}');
              } catch (e) {
                print('Sign-in failed: $e');
              }
            },
            child: Text('Sign In'),
          ),
        ),
      ),
    );
  }
}
```

### Conclusion

The `firebase_dart_admin_auth_sdk` package simplifies connecting to Firebase and performing authentication operations in a Flutter project. By following the steps outlined above, you can easily integrate Firebase authentication into your Flutter applications using service account keys, environment variables, or service account without key impersonation. For more detailed information on Firebase authentication and other Firebase services, please refer to the official Firebase documentation.