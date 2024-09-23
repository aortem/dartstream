## 0.0.1-pre+4

- Update dart format for static analysis
- update to latest dart standard package
- Sample App Package Name Fix
- Service Account Firebase initialization method on Sample App fixed
- FirebaseAuth.createUserWithEmailAndPassword feature implemented in Sample App
- FirebaseAuth.signInWithEmailAndPassword feature implemeneted in Sample App
- Initialize Firebase with Environment Variables GCP Auth Method # 2 implemented in Sample App
- FirebaseAuth.connectAuthEmulator feature implemented in Sample App
- FirebaseAuth.signInWithCredential (Google) implemented in Sample App
- FirebaseAuth.setLanguageCode() implemented in Sample App
- FirebaseUser.updatePassword() implemented in Sample App
- FirebaseUser.reload() implemented in Sample App
- FirebaseUser.unlink(Google, Apple) - auth provider Google & Apple implemented in Sample App
- FirebaseUser.sendEmailVerification() implemented in Sample App
- FirebaseAuth.revokeAccessToken() implemented in Sample App
- FirebaseAuth.applyActionCode implemented in Sample App
- Update the User model
- Added a copy with function to the user model
- Used the copy with function in the updateUser method.
- Added web and grpc libraries to the pubspec.yaml_

## 0.0.1-pre+3

- Update sendPasswordResetEmail
- Update revokeAccessToken
- Update onIdTokenChanged
- Update onAuthStateChanged
- Update isSignInWithEmailLink
- Update dispose method

## 0.0.1-pre+2

- Add sendPasswordResetEmail
- Add revokeAccessToken
- Add onIdTokenChanged
- Add onAuthStateChanged
- Add isSignInWithEmailLink
- Add dispose method

## 0.0.1-pre+1

- Add new authentication methods to FirebaseAuth class
- Implement signInWithCustomToken, signInWithCredential, sendSignInLinkToEmail, and signInWithEmailLink
- Update test suite with new tests for added functions
- Resolve ActionCodeSettings import and usage issues in tests
- Update README with documentation for new authentication methods
- Improve error handling and response parsing for all auth methods
- Ensure compatibility with latest Firebase Auth API changes
- Update Documentation and support subscriptions.

## 0.0.1-pre

- Initial pre-release version of the Firebase Dart Admin Auth SDK.
