<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">Firebase Dart Admin Auth SDK</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/firebase-dart-admin-auth-sdk/tags">
    <img alt="GitHub Tag" src="https://img.shields.io/github/v/tag/aortem/firebase-dart-admin-auth-sdk?style=for-the-badge" />
  </a>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/firebase_dart_admin_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/firebase_dart_admin_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
<!-- x-hide-in-docs-start -->

# Firebase Dart Admin Auth SDK

Firebase Dart Admin Auth SDK is designed to provide select out of the box features of Firebase in Dart.  Both low level and high level abstractions are provided.

## Features
This implementation does not yet support all functionalities of the firebase authentication service. Here is a list of functionalities with the current support status:

| Method                                       | Supported |
|--------------------------------------------- |-----------|
| FirebaseApp.getAuth                          | ✅        |
| FirebaseApp.initializeAuth                   | ✅        |
| FirebaseStorage.getStorage                   | ✅        |
| FirebaseAuth.applyActionCode                 | ✅        |
| FirebaseAuth.beforeAuthStateChanged          | ✅        |
| FirebaseAuth.checkActionCode                 | ✅        |
| FirebaseAuth.confirmPasswordReset            | ✅        |
| FirebaseAuth.connectAuthEmulator             | ✅        |
| FirebaseAuth.createUserWithEmailAndPassword  | ✅        |
| FirebaseAuth.fetchSignInMethodsForEmail      | ✅        |
| FirebaseAuth.getMultiFactorResolver          | ✅        |
| FirebaseAuth.getRedirectResult               | ✅        |
| FirebaseAuth.initializeRecaptchaConfig       | ✅        |
| FirebaseAuth.isSignInWithEmailLink           | ✅        |
| FirebaseAuth.onAuthStateChanged              | ✅        |
| FirebaseAuth.onIdTokenChanged                | ✅        |
| FirebaseAuth.revokeAccessToken               | ✅        |
| FirebaseAuth.sendPasswordResetEmail          | ✅        |
| FirebaseAuth.sendSignInLinkToEmail           | ✅        |
| FirebaseAuth.setLanguageCode                 | ✅        |
| FirebaseAuth.setPersistence                  | ✅        |
| FirebaseAuth.signInAnonymously               | ✅        |
| FirebaseAuth.signInWithCredential            | ✅        |
| FirebaseAuth.signInWithCustomToken           | ✅        |
| FirebaseAuth.signInWithEmailAndPassword      | ✅        |
| FirebaseAuth.signInWithEmailLink             | ✅        |
| FirebaseAuth.signInWithPhoneNumber           | ✅        |
| FirebaseAuth.signInWithPopup                 | ✅        |
| FirebaseAuth.signInWithRedirect              | ✅        |
| FirebaseAuth.signOut                         | ✅        |
| FirebaseAuth.updateCurrentUser               | ✅        |
| FirebaseAuth.useDeviceLanguage               | ✅        |
| FirebaseAuth.verifyPasswordResetCode         | ✅        |
| FirebaseLink.parseActionCodeURL              | ✅        |
| FirebaseUser.deleteUser                      | ✅        |
| FirebaseUser.getIdToken                      | ✅        |
| FirebaseUser.getIdTokenResult                | ✅        |
| FirebaseUser.linkWithCredential              | ✅        |
| FirebaseUser.linkWithPhoneNumber             | ✅        |
| FirebaseUser.linkWithPopup                   | ✅        |
| FirebaseUser.linkWithRedirect                | ✅        |
| FirebaseUser.multiFactor                     | ✅        |
| FirebaseUser.reauthenticateWithCredential    | ✅        |
| FirebaseUser.reauthenticateWithPhoneNumber   | ✅        |
| FirebaseUser.reauthenticateWithPopUp         | ✅        |
| FirebaseUser.reauthenticateWithRedirect      | ✅        |
| FirebaseUser.reload                          | ✅        |
| FirebaseUser.sendEmailVerification           | ✅        |
| FirebaseUser.unlink                          | ✅        |
| FirebaseUser.updateEmail                     | ✅        |
| FirebaseUser.updatePassword                  | ✅        |
| FirebaseUser.updatePhoneNumber               | ✅        |
| FirebaseUser.updateProfile                   | ✅        |
| FirebaseUser.verifyBeforeUpdateEmail         | ✅        |
| FirebaseUserCredential.getAdditionalUserInfo | ✅        |


## Available Versions

Firebase Dart Admin Auth SDK is available in two versions to cater to different needs:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Sample Apps - FrontEnd Version**: The sample apps are provided in various frontend languages in order to allow maximum flexibility with your frontend implementation with the Dart backend.  Note that new features are first tested in the sample apps before being released in the mainline branch. Use only as a guide for your frontend/backend implementation of Dart.

## Documentation

For detailed guides, API references, and example projects, visit our [Firebase Dart Admin Auth SDK Documentation](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk). Start building with  Firebase Dart Admin Auth SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Firebase Dart Admin Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Firebase Dart Admin Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support

For support across all Aortem open-source products, including this SDK, visit our [Support Page](https://aortem.io/support).


## Licensing

The **EntraID Dart Auth SDK** is licensed under a dual-license approach:

1. **BSD-3 License**:
   - Applies to all packages and libraries in the SDK.
   - Allows use, modification, and redistribution, provided that credit is given and compliance with the BSD-3 terms is maintained.
   - Permits usage in open-source projects, applications, and private deployments.

2. **Enhanced License Version 2 (ELv2)**:
   - Applies to all use cases where the SDK or its derivatives are offered as part of a **cloud service**.
   - This ensures that the SDK cannot be directly used by cloud providers to offer competing services without explicit permission.
   - Example restricted use cases:
     - Including the SDK in a hosted SaaS authentication platform.
     - Offering the SDK as a component of a managed cloud service.

### **Summary**
- You are free to use the SDK in your applications, including open-source and commercial projects, as long as the SDK is not directly offered as part of a third-party cloud service.
- For details, refer to the [LICENSE](LICENSE.md) file.

## Enhance with Firebase Dart Admin Auth SDK

We hope the Firebase Dart Admin Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!  test