## 0.0.1-pre+21

- update SDK to 3.7.2

## 0.0.1-pre+20

- update SDK to 3.7.0

## 0.0.1-pre+19

- additional update to firebase.verifyidtoken method

## 0.0.1-pre+18

- add firebase.verifyidtoken method

## 0.0.1-pre+17

HotFix: 
 - Impersonate Service Account Without keys update.
 - Reverting to the previous method name FirebaseApp.```initializeAppWithServiceAccountImpersonationGCP```

## 0.0.1-pre+16

- Create a service account without using the key impersonation method
- Authenticate using the service account email and project ID
- Obtain ADC (Application Default Credentials) from Google Cloud for authentication
- Remove all incorrect code and previous methods related to this function

## 0.0.1-pre+15

- support service account without impersonation key
- remove node modules

## 0.0.1-pre+14

- Update Yaml file for core dependencies
- add service account impersonation via gap
- update the api call of the following:
  - apple sign in auth
  - send verification code
  - sign in with redirect
  - refresh token
  - check action code
  - confirm password
  - create account with email and password
  - fetch sign in methods
  - send password reset email
  - send verification code

## 0.0.1-pre+13

- Update SDK version to 3.6.0

## 0.0.1-pre+12

- Update SDK version formatting

## 0.0.1-pre+11

- add sign in with redirect & link with credentials & verify password reset code
- add Micorsoft Integration
- update documentation: Added `auth_redirect_link'.
- add feat (auth): Completed the "Sign in with Microsoft" feature and integrated it into a sample app.
- added webView to open apple sign-page page(uses 'client_id=YOUR_SERVICES_ID&')
- fix(code): Removed unused files:
- auth_link_with_phone_number_stub.dart
- auth_redirect_link_stub.dart

## 0.0.1-pre+10

- Add debug initialization in sample app for better testing
- Add Sign In With Facebook To Sample App.
- Add Remaining Signin Methods to the Sample App
- Introduce unit and integration testing
- Update remaining doc dart issues for code clarity 

## 0.0.1-pre+9

- Update changelog format of previous release
- Update service account format

## 0.0.1-pre+8

- Add Linter rules for public_members and better code transperancy
- Add initalization with Service Account Impersonation and proper documentation
- Update Gradle Build files and dependencies
- Implement FirebaseAuth.signInWithCustomToken in Sample App
- Implement FirebaseAuth.generateCustomToken in Sample App
- Implement FirebaseAuth.verifyPasswordResetCode in Sample App
- Improve Dart Doc Comments

## 0.0.1-pre+7

- Added README.md for example folder naming conventions.

## 0.0.1-pre+6

- Updated pub.dev README and feature check list for -pre+6 release
- FirebaseUser.linkWithPopup implemented in Sample App
- FirebaseUser.linkWithCredential implemented in Sample App
- FirebaseAuth.signInWithPhoneNumber implemented in Sample App
- FirebaseAuth.getRedirectResult implemented in Sample App
- FirebaseAuth.signInWithRedirect implemented in Sample App
- FirebaseApp.getAuth implemented in Sample App
- FirebaseApp.initializeAuth implemented in Sample App
- Moved example folder for the sample app to proper location for dart conventions.

## 0.0.1-pre+5

- FirebaseStorage.getStorage added to Sample App
- FirebaseAuth.setPersistence added to Sample App
- FirebaseAuth.initializeRecaptchaConfig Method implemented in Sample App
- FirebaseAuth.confirmPasswordReset Method implemented in Sample App
- FirebaseAuth.isSignInWithEmailLink Method implemented in Sample App
- FirebaseAuth.checkActionCode added to Sample App

## 0.0.1-pre+4

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
- Added web and grpc libraries to the pubspec.yaml
- FirebaseAuth.signOut feature implemented in the Sample App
- FirebaseAuth.updateCurrentUser feature implemented in Sample App
- FirebaseLink.parseActionCodeURL feature implemented in Sample App
- FirebaseUser.deleteUser feature implemented in Sample App
- FirebaseUser.getIdToken feature implemented in Sample App
- FirebaseUser.getIdTokenResult feature implemented in Sample App
- FirebaseAuth.getMultiFactorResolver Method implemented in Sample App
- FirebaseAuth.fetchSignInMethodsForEmail implemented in Sample App
- FirebaseAuth.connectAuthEmulator implemented in Sample App
- FirebaseAuth.sendPasswordResetEmail Method implemented in Sample App
- FirebaseAuth.revokeAccessToken Method implemented in Sample App
- FirebaseAuth.onIdTokenChanged Method implemented in Sample App
- FirebaseAuth.onAuthStateChanged Method implemented in Sample App

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
