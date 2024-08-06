# Firebase Dart Admin Auth SDK

Firebase Dart Admin Auth SDK is designed to provide select out of the box features of Firebase in Dart.  Both low level and high level abstractions are provided.

## Features
This implementation does not yet support all functionalities of the firebase authentication service. Here is a list of functionalities with the current support status:

| Method                        | Supported                |
|-------------------------------|--------------------------|
| FirebaseApp.getAuth                          | ❌        |
| FirebaseApp.initializeAuth                   | ❌        |
| FirebaseStorage.getStorage                   | ❌        |
| FirebaseAuth.applyActionCode                 | ✅        |
| FirebaseAuth.beforeAuthStateChanged          | ❌        |
| FirebaseAuth.checkActionCode                 | ❌        |
| FirebaseAuth.confirmPasswordReset            | ❌        |
| FirebaseAuth.connectAuthEmulator             | ✅        |
| FirebaseAuth.createUserWithEmailAndPassword  | ✅        |
| FirebaseAuth.fetchSignInMethodsForEmail      | ❌        |
| FirebaseAuth.getMultiFactorResolver          | ❌        |
| FirebaseAuth.getRedirectResult               | ❌        |
| FirebaseAuth.initializeRecaptchaConfig       | ❌        |
| FirebaseAuth.isSignInWithEmailLink           | ❌        |
| FirebaseAuth.onAuthStateChanged              | ❌        |
| FirebaseAuth.onIdTokenChanged                | ❌        |
| FirebaseAuth.revokeAccessToken               | ✅        |
| FirebaseAuth.sendPasswordResetEmail          | ❌        |
| FirebaseAuth.sendSignInLinkToEmail           | ❌        |
| FirebaseAuth.setLanguageCode                 | ✅        |
| FirebaseAuth.setPersistence                  | ❌        |
| FirebaseAuth.signInAnonymously               | ❌        |
| FirebaseAuth.signInWithCredential            | ✅        |
| FirebaseAuth.signInWithCustomToken           | ❌        |
| FirebaseAuth.signInWithEmailAndPassword      | ✅        |
| FirebaseAuth.signInWithEmailLink             | ❌        |
| FirebaseAuth.signInWithPhoneNumber           | ❌        |
| FirebaseAuth.signInWithPopup                 | ❌        |
| FirebaseAuth.signInWithRedirect              | ❌        |
| FirebaseAuth.signOut                         | ❌        |
| FirebaseAuth.updateCurrentUser               | ❌        |
| FirebaseAuth.useDeviceLanguage               | ❌        |
| FirebaseAuth.verifyPasswordResetCode         | ❌        |
| FirebaseLink.parseActionCodeURL              | ❌        |
| FirebaseUser.deleteUser                      | ❌        |
| FirebaseUser.getIdToken                      | ❌        |
| FirebaseUser.getIdTokenResult                | ❌        |
| FirebaseUser.linkWithCredential              | ❌        |
| FirebaseUser.linkWithPhoneNumber             | ❌        |
| FirebaseUser.linkWithPopup                   | ❌        |
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
| FirebaseUser.updateProfile                   | ❌        |
| FirebaseUser.verifyBeforeUpdateEmail         | ❌        |
| FirebaseUserCredential.getAdditionalUserInfo | ❌        |


## Available Versions

Firebase Dart Admin Auth SDK is available in two versions to cater to different needs and scales:

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

- **Community Support**: Free, community-driven support with no guaranteed response time.
- **Standard Support**: $10/month with a two-week Initial Response Service Level Agreement (IRSLA), billed annually
- **Enhanced Support**: $100/month with a 72-hour IRSLA, billed annually.

Each tier offers escalating levels of support, from community forums to direct access to the development team.  There is a limit of one active ticket per use for standard and premium support tickets.

### Community Support
- Free support provided by the Firebase Dart Admin Auth SDK community.

### Standard Support
- $10/month - Billed Annually.
- 10 business days (Monday-Friday) IRSLA
- [Subscribe-Coming Soon]()
- **Features**:
  - Unlimited Support Tickets with Guaranteed RSLA.
  - One Open/Active Ticket at a time.

### Enhanced Support

- $100/month - Billed Annually.
- 72-hour IRSLA.
- [Subscribe-Coming Soon]()
- **Features**:
  - Everything in Standard Support Plus.
  - Access to Roadmap.
  - Feature Request Upvoting (Priority feature request).
  - One Open/Active Ticket at a time.

  ### Enterprise Support (Beta)
- $450/month - Billed Annually
- 48-hour IRSLA.
- [Subscribe](https://buy.stripe.com/cN2fZU5Db3Fx4ko6ot)
- **Features**:
  - Everything in Enhanced Support Plus:
  - Comprehensive support for a broader range of Dart backend development open source projects.
  - Premium access to our exclusive enterprise customer forum.
  - Early access to cutting-edge features.
  - Exclusive access to Partner/Reseller/Channel Program.


Enterprise Support is designed for businesses, agencies, and partners seeking top-tier support across a wide range of Dart backend and server-side projects.  All Open Source projects that are part of the Aortem Collective are included in the Enterprise subscription, with more projects being added soon.

To choose a support tier, click on one of the options above.

## Licensing

All  Firebase Dart Admin Auth SDK packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, which are licensed from third party software  Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with Firebase Dart Admin Auth SDK

We hope the Firebase Dart Admin Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!  test