<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem%20logo.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem%20logo.png" />
  </picture>
</p>

<h2 align="center">Firebase Dart Admin Auth SDK</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/firebase-dart-admin-auth-sdk/tags">
    <img alt="Release" src="https://img.shields.io/static/v1?label=release&message=v0.0.1-pre+10&color=blue&style=for-the-badge" />
  </a>
  <br/>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/firebase_dart_admin_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/firebase_dart_admin_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
 <!-- Firebase Badge -->
   <a href="https://firebase.google.com/docs/reference/admin/node/firebase-admin.auth?_gl=1*1ewipg9*_up*MQ..*_ga*NTUxNzc0Mzk3LjE3MzMxMzk3Mjk.*_ga_CW55HF8NVT*MTczMzEzOTcyOS4xLjAuMTczMzEzOTcyOS4wLjAuMA..">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
<!-- Pipeline Badge -->
<a href="https://github.com/aortem/firebase-dart-admin-auth-sdk/actions">
  <img alt="Pipeline Status" src="https://img.shields.io/github/actions/workflow/status/aortem/firebase-dart-admin-auth-sdk/dart-analysis.yml?branch=main&label=pipeline&style=for-the-badge" />
</a>
<!-- Code Coverage Badges -->
  </a>
  <a href="https://codecov.io/gh/open-feature/dart-server-sdk">
    <img alt="Code Coverage" src="https://codecov.io/gh/open-feature/dart-server-sdk/branch/main/graph/badge.svg?token=FZ17BHNSU5" />
<!-- Open Source Badge -->
  </a>
  <a href="https://bestpractices.coreinfrastructure.org/projects/6601">
    <img alt="CII Best Practices" src="https://bestpractices.coreinfrastructure.org/projects/6601/badge?style=for-the-badge" />
  </a>
</p>
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
| FirebaseUser.linkWithRedirect                | ❌        |
| FirebaseUser.multiFactor                     | ❌        |
| FirebaseUser.reauthenticateWithCredential    | ❌        |
| FirebaseUser.reauthenticateWithPhoneNumber   | ❌        |
| FirebaseUser.reauthenticateWithPopUp         | ❌        |
| FirebaseUser.reauthenticateWithRedirect      | ❌        |
| FirebaseUser.reload                          | ✅        |
| FirebaseUser.sendEmailVerification           | ✅        |
| FirebaseUser.unlink                          | ✅        |
| FirebaseUser.updateEmail                     | ❌        |
| FirebaseUser.updatePassword                  | ✅        |
| FirebaseUser.updatePhoneNumber               | ❌        |
| FirebaseUser.updateProfile                   | ✅        |
| FirebaseUser.verifyBeforeUpdateEmail         | ✅        |
| FirebaseUserCredential.getAdditionalUserInfo | ✅        |


## Available Versions

Firebase Dart Admin Auth SDK is available in two versions to cater to different needs:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Pre-Release - Edge Version**: Provided as an early indication of a release when breaking changes are expect.  This release is inconsistent. Use only if you are looking to test new features.

## Documentation

For detailed guides, API references, and example projects, visit our [Firebase Dart Admin Auth SDK Documentation](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk). Start building with  Firebase Dart Admin Auth SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Firebase Dart Admin Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Firebase Dart Admin Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support Tiers

Firebase Dart Admin Auth SDK offers various support tiers for our open-source products with an Initial Response Service Level Agreement (IRSLA):

### Community Support
- **Cost**: Free
- **Features**: Access to community forums, basic documentation.
- **Ideal for**: Individual developers or small startups.
- **SLA**: NA

### Standard Support
- **Cost**: $10/month - Billed Annually.
- **Features**: Extended documentation, email support, 10 business days response SLA.
- **Ideal for**: Growing startups and small businesses.
- **SLA**: 10 business days (Monday-Friday) IRSLANA
- [Subscribe-Coming Soon]()

### Enhanced Support
- **Cost**: $100/month - Billed Annually
- **Features**: Access to roadmap, 72-hour response SLA, feature request prioritization.
- **Ideal for**: Medium-sized enterprises requiring frequent support.
- **SLA**: 5 business days IRSLA
- [Subscribe-Coming Soon]()

### Enterprise Support
- **Cost**: 450/month
- **Features**: 
  - 48-hour response SLA, 
  - Access to beta features:
  - Comprehensive support for all Aortem Open Source products.
  - Premium access to our exclusive enterprise customer forum.
  - Early access to cutting-edge features.
  - Exclusive access to Partner/Reseller/Channel Program..
- **Ideal for**: Large organizations and enterprises with complex needs.
- **SLA**: 48-hour IRSLA
- [Subscribe-Coming Soon]()

*Enterprise Support is designed for businesses, agencies, and partners seeking top-tier support across a wide range of Dart backend and server-side projects.  All Open Source projects that are part of the Aortem Collective are included in the Enterprise subscription, with more projects being added soon.

## Licensing

All  Firebase Dart Admin Auth SDK packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, which are licensed from third party software  Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with Firebase Dart Admin Auth SDK

We hope the Firebase Dart Admin Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!  test