# Aortem Firebase Dart SDK

Aortem Firebase Dart SDK is an SDK designed to provide select out of the box features of Firebase in Dart.  Both loww level and high leve abstractions are provided.

## Features
This implementation does not yet support all functionalities of the firebase authentication service. Here is a list of functionalities with the current support status:
| Method                                   | Supported |
|------------------------------------------|-----------|
| FirebaseAuth.applyActionCode             | ✅         |
| FirebaseAuth.authStateChanges            | ✅         |
| FirebaseAuth.checkActionCode             | ✅         |
| FirebaseAuth.confirmPasswordReset        | ✅         |
| FirebaseAuth.createUserWithEmailAndPassword | ✅       |
| FirebaseAuth.fetchSignInMethodsForEmail  | ✅         |
| FirebaseAuth.getRedirectResult           | ❌         |
| FirebaseAuth.idTokenChanges              | ✅         |
| FirebaseAuth.isSignInWithEmailLink       | ✅         |
| FirebaseAuth.sendPasswordResetEmail      | ✅         |
| FirebaseAuth.sendSignInLinkToEmail       | ✅         |
| FirebaseAuth.setLanguageCode             | ✅         |
| FirebaseAuth.setPersistence              | ❌         |
| FirebaseAuth.signInAnonymously           | ✅         |
| FirebaseAuth.signInWithCredential        | ✅         |
| FirebaseAuth.signInWithCustomToken       | ✅         |
| FirebaseAuth.signInWithEmailAndPassword  | ✅         |
| FirebaseAuth.signInWithEmailLink         | ✅         |
| FirebaseAuth.signInWithPhoneNumber       | ✅         |
| FirebaseAuth.signInWithPopup             | ❌         |
| FirebaseAuth.signInWithRedirect          | ❌         |
| FirebaseAuth.signInWithAuthProvider      | ❌         |
| FirebaseAuth.signOut                     | ✅         |
| FirebaseAuth.userChanges                 | ✅         |
| FirebaseAuth.verifyPasswordResetCode     | ✅         |
| FirebaseAuth.verifyPhoneNumber           | ✅         |
| User.delete                              | ✅         |
| User.getIdToken                          | ✅         |
| User.getIdTokenResult                    | ✅         |
| User.linkWithCredential                  | ❌         |
| User.linkWithPhoneNumber                 | ❌         |
| User.reauthenticateWithCredential        | ✅         |
| User.reload                              | ✅         |
| User.sendEmailVerification               | ✅         |
| User.unlink                              | ✅         |
| User.updateEmail                         | ✅         |
| User.updatePassword                      | ✅         |
| User.updatePhoneNumber                   | ❌         |
| User.updateProfile                       | ✅         |
| User.verifyBeforeUpdateEmail             | ❌         |
| User.multiFactor                         | ✅         |

## Available Versions

Aortem Firebase Dart SDK is available in two versions to cater to different needs and scales:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Pre-Release - Edge Version**: Provided as an early indication of a release when breaking changes are expect.  This release is inconsistent. Use only if you are looking to test new features.

## Documentation

For detailed guides, API references, and example projects, visit our [Aortem Firebase Dart SDK Documentation](#). Start building with Aortem Firebase Dart SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating Aortem Firebase Dart SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve Aortem Firebase Dart SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.

## Support Tiers

Aortem Firebase Dart Authentication SDK offers various support tiers for our open-source products:

- **Community Support**: Free, community-driven support with no guaranteed response time.
- **Standard Support**: $15/month with a two-week Initial Response Service Level Agreement (IRSLA), billed annually
- **Premium Support**: $100/month with a 72-hour IRSLA, billed annually.
- **Enterprise/Partner Support**: $999/month with a 24-hour IRSLA, billed annually.

Each tier offers escalating levels of support, from community forums to direct access to the development team.  There is a limit of one active ticket per use for standard and premium support tickets.

### Community Support
- Free support provided by the Aortem Firebase Dart SDK community.

### Standard Support
- $15/month.
- 10 business days (Monday - Friday) Initial Response Service Level Agreement (IRSLA).
- [Subscribe](https://buy.stripe.com/bIYcPL615erv3y8001)
- **Features**:
  - Unlimited Support Tickets with Guaranteed RSLA.
  - One Open/Active Ticket at a time. 

### Enhanced Support
- $100/month - Billed Annually.
- 72-hour IRSLA.
- [Subscribe](https://buy.stripe.com/bIY9Dz759abf5Gg4gi)
- **Features**:
  - Everything in Standard Support.
  - Access to Roadmap.
  - Feature Request Upvoting (Priority feature request).
  - One Open/Active Ticket at a time.

### Enterprise Support
- $999/month - Billed Annually
- 24-hour IRSLA.
- [Subscribe](https://buy.stripe.com/8wMg1X2OT97b7OoeUX)
- **Features**:
  - Everything in Enhanced Support.
  - Early Access to new features.
  - Access to our network channels.
  - Monthly access to Development/Partner Calls.
  - Access to Partner/Reseller/Channel Program.
  - Option to include Logo on the Open Source website.

To choose a support tier, click on one of the options above.

## Licensing

All Aortem Firebase Dart SDK packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with Aortem Firebase Dart SDK"

We hope Aortem Firebase Dart SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!