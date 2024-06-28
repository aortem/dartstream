
# Aortem Firebase Dart SDK

Aortem Firebase Dart SDK provides easy-to-use methods for integrating Firebase Authentication into your Dart and Flutter projects.

## Features


- Sign in with custom token
- Sign in with credential
- Sign in with email and password
- Sign in with popup for OAuth providers
- Sign in with phone number
- Sign in with email link

## Installation

To use this package, add `aortem_firebase_dart_sdk` as a dependency in your `pubspec.yaml` file.

### Adding via command line

Open your terminal and run:

```bash
dart pub add aortem_firebase_dart_sdk
This command adds the package to your dart project and installs the latest version.

Manually Adding
Alternatively, you can manually add the package to your pubspec.yaml file:

yaml

dependencies:
  http: ^1.2.1
  aortem_firebase_dart_sdk: ^0.0.1-pre  # Replace with the latest version

Then, run dart pub get to install the package:

dart pub get

Initialize Firebase
First, initialize Firebase in your Dart application:


import 'package:aortem_firebase_dart_sdk/aortem_firebase_dart_sdk.dart';

void main() async {
  // Initialize Firebase app
  FirebaseAuth auth = FirebaseAuth(
    apiKey: 'your_api_key',
    projectId: 'your_project_id',
  );

  // Example usage
  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword('user@example.com', 'password123');
    print('Signed in: ${userCredential.user.email}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}

  Authentication Methods

  Sign in with Email and Password

  // Example: Sign in with email and password
  try {
  UserCredential userCredential = await auth.signInWithEmailAndPassword(
    'user@example.com',
    'password123'
  );
  print('Signed in: ${userCredential.user.email}');
} catch (e) {
  print('Sign-in error: $e');
}

Sign in with Custom Token

try {
  UserCredential userCredential = await auth.signInWithCustomToken('your-custom-token');
  print('Signed in with custom token: ${userCredential.user.uid}');
} catch (e) {
  print('Sign-in error: $e');
}


Sign in with Email Link

try {
  await auth.sendSignInLinkToEmail(
    email: 'user@example.com',
    actionCodeSettings: ActionCodeSettings(
      url: 'https://your-app.com/finishSignUp',
      handleCodeInApp: true,
      // ... other settings
    ),
  );
  print('Email link sent successfully');
} catch (e) {
  print('Error sending email link: $e');
}

// Later, when the user clicks the link:
try {
  UserCredential userCredential = await auth.signInWithEmailLink(
    email: 'user@example.com',
    emailLink: 'received-email-link'
  );
  print('Signed in with email link: ${userCredential.user.email}');
} catch (e) {
  print('Sign-in error: $e');
}


Sign in with Phone Number

try {
  ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+1234567890');
  // Prompt user for the SMS code
  UserCredential userCredential = await confirmationResult.confirm('123456');
  print('Signed in with phone number: ${userCredential.user.phoneNumber}');
} catch (e) {
  print('Sign-in error: $e');
}


Sign in with Credential

try {
  AuthCredential credential = EmailAuthProvider.credential(
    email: 'user@example.com',
    password: 'password123'
  );
  UserCredential userCredential = await auth.signInWithCredential(credential);
  print('Signed in with credential: ${userCredential.user.email}');
} catch (e) {
  print('Sign-in error: $e');
}


Sign in with Popup (OAuth)

try {
  UserCredential userCredential = await auth.signInWithPopup(GoogleAuthProvider());
  print('Signed in with Google: ${userCredential.user.email}');
} catch (e) {
  print('Sign-in error: $e');
}

User Management

Create User

try {
  UserCredential userCredential = await auth.createUserWithEmailAndPassword(
    'newuser@example.com',
    'password123'
  );
  print('User created: ${userCredential.user.email}');
} catch (e) {
  print('User creation error: $e');
}


Update User Profile

try {
  await auth.currentUser?.updateProfile(displayName: 'John Doe', photoURL: 'https://example.com/photo.jpg');
  print('User profile updated');
} catch (e) {
  print('Profile update error: $e');
}


Delete User

try {
  await auth.currentUser?.delete();
  print('User deleted');
} catch (e) {
  print('User deletion error: $e');
}

Error Handling

The SDK uses FirebaseAuthException for error handling. Always wrap your authentication calls in try-catch blocks to handle potential errors gracefully.

Testing

To run the tests for this package, add the following dev dependency to your pubspec.yaml:


dev_dependencies:
  test: ^1.21.0  # Replace with the latest version

Then, run the tests using:
dart test
