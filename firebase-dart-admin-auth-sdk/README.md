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



<!-- usman babar  -->
# Firebase Dart Admin Auth SDK

A Dart package that provides Firebase Authentication features without using Firebase Auth and Firebase Core. This package allows you to perform authentication requests using HTTP directly.

## Features

- **Email/Password Authentication**
  - `signInWithEmailAndPassword`
  - `createUserWithEmailAndPassword`
- **Custom Token Authentication**
  - `signInWithCustomToken`
- **Email Link Authentication**
  - `sendSignInLinkToEmail`
  - `signInWithEmailLink`
- **Credential Authentication**
  - `signInWithCredential`
- **OAuth Authentication**
  - `signInWithRedirect`
  - `signInWithPopup`
- **User Management**
  - `updateCurrentUser`
  - `useDeviceLanguage`
  - `verifyPasswordResetCode`
  - `signOut`

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_dart_admin_auth_sdk:
    git:
      url: https://github.com/yourusername/firebase_dart_admin_auth_sdk.git
Usage
Initialization
First, initialize FirebaseAuth with your Firebase project configuration:
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

void main() {
  final auth = FirebaseAuth(
    apiKey: 'your-api-key',
    projectId: 'your-project-id',
  );
}
Sign In with Email and Password
void signInWithEmail() async {
  try {
    final result = await auth.signInWithEmailAndPassword('email@example.com', 'password');
    print('Signed in: ${result.user.uid}');
  } catch (e) {
    print('Sign in failed: $e');
  }
}
Create User with Email and Password
void createUser() async {
  try {
    final result = await auth.createUserWithEmailAndPassword('email@example.com', 'password');
    print('User created: ${result.user.uid}');
  } catch (e) {
    print('User creation failed: $e');
  }
}
Sign In with Custom Token
void signInWithCustomToken() async {
  try {
    final result = await auth.signInWithCustomToken('your-custom-token');
    print('Signed in with custom token: ${result.user.uid}');
  } catch (e) {
    print('Sign in failed: $e');
  }
}
Send Sign In Link to Email
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart' as acs;

void sendSignInLink() async {
  try {
    final settings = acs.ActionCodeSettings(
      url: 'https://example.com/finishSignUp?cartId=1234',
      handleCodeInApp: true,
    );
    await auth.sendSignInLinkToEmail('email@example.com', settings);
    print('Sign-in link sent');
  } catch (e) {
    print('Failed to send sign-in link: $e');
  }
}
Sign In with Email Link
void signInWithEmailLink() async {
  try {
    final result = await auth.signInWithEmailLink('email@example.com', 'https://example.com?oobCode=abc123');
    print('Signed in with email link: ${result.user.uid}');
  } catch (e) {
    print('Sign in failed: $e');
  }
}
Sign Out
void signOut() async {
  try {
    await auth.signOut();
    print('Signed out');
  } catch (e) {
    print('Sign out failed: $e');
  }
}
Update Current User
void updateCurrentUser() async {
  try {
    await auth.updateUserInformation('user-id', {'displayName': 'New Display Name'});
    print('User updated');
  } catch (e) {
    print('Update failed: $e');
  }
}
Use Device Language
void useDeviceLanguage() async {
  try {
    await auth.useDeviceLanguage('user-id', 'en');
    print('Device language set');
  } catch (e) {
    print('Failed to set device language: $e');
  }
}
Verify Password Reset Code
void verifyPasswordResetCode() async {
  try {
    final result = await auth.verifyPasswordResetCode('reset-code');
    print('Password reset code verified: ${result['email']}');
  } catch (e) {
    print('Verification failed: $e');
  }
}
Testing
To run tests, use the following command:
dart test
Contributing
Contributions are welcome! Please open an issue or submit a pull request.
License
This project is licensed under the MIT License. See the LICENSE file for details.
markdown

### Notes:
- Replace `https://github.com/yourusername/firebase_dart_admin_auth_sdk.git` with the actual URL of your repository.
- Adjust the `LICENSE` file reference if it differs.

This README provides an overview of the package, installation instructions, usage examples for key features, and testing instructions. Feel free to customize it further based on your specific needs and additional features.
4o

Certainly! Here are detailed steps for users to initialize Firebase using the `firebase_dart_admin_auth_sdk` package with three different methods: using a service account with keys, environment variables, and service account without key impersonation.

### Step-by-Step Guide to Initialize Firebase with `firebase_dart_admin_auth_sdk`

#### Method 1: Using Service Account with Keys

1. **Download Service Account Key File**
   - Obtain a service account key file (`json` format) from the Firebase Console:
     - Go to Firebase Console: [https://console.firebase.google.com/](https://console.firebase.google.com/).
     - Navigate to your project.
     - Go to Project Settings > Service accounts.
     - Click on "Generate new private key" and download the JSON file.
   
2. **Include `firebase_dart_admin_auth_sdk` in Your Dart Project**
   - Ensure you have added `firebase_dart_admin_auth_sdk` as a dependency in your `pubspec.yaml` file:
     ```yaml
     dependencies:
       firebase_dart_admin_auth_sdk: ^0.0.1-pre
     ```
   - Run `dart pub get` to install the package.

3. **Set Up Firebase Initialization in Dart**

   Create a Dart script (`bin/main.dart`) to initialize Firebase using the service account key file:
   ```dart
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

4. **Run the Dart Script**
   - Open your terminal or command prompt.
   - Navigate to your Dart project directory (`cd path/to/your/project`).
   - Execute the Dart script:
     ```bash
     dart bin/main.dart
     ```

#### Method 2: Using Environment Variables

1. **Set Environment Variables**
   - Before running the Dart script, set environment variables for your Firebase API key and project ID:
     ```bash
     set FIREBASE_API_KEY=your_api_key
     set FIREBASE_PROJECT_ID=your_project_id
     ```
   - Replace `"your_api_key"` and `"your_project_id"` with your actual Firebase API key and project ID.

2. **Modify Dart Script**

   Update your Dart script (`bin/main.dart`) to initialize Firebase using environment variables:
   ```dart
   import 'dart:async';
   import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

   Future<void> main(List<String> arguments) async {
     // Initialize FirebaseAuth using environment variables
     final auth = FirebaseAuth.fromEnvironmentVariables(
       apiKeyEnvVar: 'FIREBASE_API_KEY',
       projectIdEnvVar: 'FIREBASE_PROJECT_ID',
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

3. **Run the Dart Script**
   - Open your terminal or command prompt.
   - Navigate to your Dart project directory (`cd path/to/your/project`).
   - Execute the Dart script:
     ```bash
     dart bin/main.dart
     ```

#### Method 3: Using Service Account without Key Impersonation

1. **Modify Dart Script**

   Update your Dart script (`bin/main.dart`) to initialize Firebase without key impersonation:
   ```dart
   import 'dart:async';
   import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

   Future<void> main(List<String> arguments) async {
     // Initialize FirebaseAuth without key impersonation
     final auth = FirebaseAuth.fromServiceAccountWithoutKeyImpersonation(
       serviceAccountEmail: 'service_account_email',
       userEmail: 'user_email',
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

2. **Run the Dart Script**
   - Open your terminal or command prompt.
   - Navigate to your Dart project directory (`cd path/to/your/project`).
   - Execute the Dart script:
     ```bash
     dart bin/main.dart
     ```

### Additional Notes:

- Ensure you replace placeholders (`path/to/serviceAccountKey.json`, `your_api_key`, `your_project_id`, `service_account_email`, `user_email`) with your actual values.
- The Dart script examples demonstrate signing in with email and password as an example. You can modify these to use other authentication methods provided by the `firebase_dart_admin_auth_sdk` package.

By following these steps, users can effectively initialize Firebase in Dart using the `firebase_dart_admin_auth_sdk` package with their preferred method: service account with keys, environment variables, or service account without key impersonation. Adjustments to the Dart script can accommodate various Firebase authentication scenarios based on project requirements.