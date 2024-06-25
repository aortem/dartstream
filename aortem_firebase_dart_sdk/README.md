
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
flutter pub add aortem_firebase_dart_sdk
This command adds the package to your Flutter project and installs the latest version.

Manually Adding
Alternatively, you can manually add the package to your pubspec.yaml file:

yaml

dependencies:
  flutter:
    sdk: flutter
  aortem_firebase_dart_sdk: ^1.0.0  # Replace with the latest version
Then, run flutter pub get to install the package:

bash

flutter pub get
Usage
Import the package into your Dart file:

dart

import 'package:aortem_firebase_dart_sdk/aortem_firebase_dart_sdk.dart';
import 'package:firebase_dart/firebase_dart.dart';

void main() async {
  // Initialize Firebase app
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'your_api_key',
      authDomain: 'your_auth_domain',
      projectId: 'your_project_id',
      storageBucket: 'your_storage_bucket',
      messagingSenderId: 'your_messaging_sender_id',
      appId: 'your_app_id',
    ),
  );

  // Initialize FirebaseAuthService instance
  FirebaseAuthService authService = FirebaseAuthService();

  // Example: Sign in with email and password
  try {
    UserCredential userCredential = await authService.signInWithEmailAndPassword('test@example.com', 'password');
    print('Signed in: ${userCredential.user!.email}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}

Sign In with Popup

import 'package:firebase_dart/firebase_dart.dart';

void signInWithPopupExample() async {
  FirebaseAuthService authService = FirebaseAuthService();

  try {
    UserCredential userCredential = await authService.signInWithPopup(GoogleAuthProvider());
    print('Signed in with popup: ${userCredential.user!.email}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}
Sign In with Phone Number

import 'package:firebase_dart/firebase_dart.dart';

void signInWithPhoneNumberExample() async {
  FirebaseAuthService authService = FirebaseAuthService();

  try {
    String phoneNumber = '1234567890';
    RecaptchaVerifier recaptchaVerifier = RecaptchaVerifier(
      container: 'recaptcha-container',
      auth: FirebaseAuth.instance,
    );

    ConfirmationResult confirmationResult = await authService.startSignInWithPhoneNumber(phoneNumber, recaptchaVerifier);
    print('Verification ID: ${confirmationResult.verificationId}');

    // After receiving the verification code from the user
    String verificationCode = '123456';
    UserCredential userCredential = await authService.confirmSignInWithPhoneNumber(confirmationResult, verificationCode);
    print('Signed in with phone number: ${userCredential.user!.phoneNumber}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}
Sign In with Email Link

import 'package:firebase_dart/firebase_dart.dart';

void signInWithEmailLinkExample() async {
  FirebaseAuthService authService = FirebaseAuthService();

  try {
    UserCredential userCredential = await authService.signInWithEmailLink(
      email: 'test@example.com',
      emailLink: 'your_email_link',
    );
    print('Signed in with email link: ${userCredential.user!.email}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}


Sign In with Custom Token

import 'package:firebase_dart/firebase_dart.dart';

void signInWithCustomTokenExample() async {
  FirebaseAuthService authService = FirebaseAuthService();

  try {
    UserCredential userCredential = await authService.signInWithCustomToken('your_custom_token');
    print('Signed in with custom token: ${userCredential.user!.uid}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}
Sign In with Credential

import 'package:firebase_dart/firebase_dart.dart';

void signInWithCredentialExample() async {
  FirebaseAuthService authService = FirebaseAuthService();

  try {
    AuthCredential credential = EmailAuthProvider.credential(email: 'test@example.com', password: 'password');
    UserCredential userCredential = await authService.signInWithCredential(credential);
    print('Signed in with credential: ${userCredential.user!.email}');
  } catch (e) {
    print('Sign-in error: $e');
  }
}
Testing
You can run tests for this package using the test package. Add test as a dev dependency in your pubspec.yaml file:

yaml
Copy code
dev_dependencies:
  test: ^1.16.0  # Replace with the latest version
Then, create test files in the test directory and run them using:
