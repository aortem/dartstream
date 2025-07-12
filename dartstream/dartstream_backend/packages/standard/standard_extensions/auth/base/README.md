# DartStream

## DS Auth Base Package

This package is designed to support the integration of authnetication providers. 

The **DS Auth Base** package is the foundational layer for all DartStream authentication integrations. It defines the common interfaces, manager logic, and export entrypoint that every provider package builds upon, so you can swap or extend providers without rewriting your app’s authentication core.

**Key components**  
- **`ds_auth_base_export.dart`** – Re-exports the base interfaces and manager.  
- **`DSAuthProvider`** – Abstract interface all providers must implement (`initialize`, `signIn`, `signOut`, etc.).  
- **`DSAuthManager`** – Central registry and runtime selector for whichever provider you choose.DS 

---

## Supported Authentication SDKs

DartStream provides first-class integration with the following 10 authentication SDKs. Install them via Pub and find source, issues, and examples on GitHub:

| Provider        | Package Name                   | Pub Dev                                                          | GitHub                                                            |
| --------------- | ------------------------------ | ---------------------------------------------------------------- | ----------------------------------------------------------------- |
| **Auth0**       | `auth0_dart-auth-sdk`          | [pub.dev](https://pub.dev/packages/auth0_dart_auth_sdk)          | [github](https://github.com/aortem/auth0-dart-auth-sdk)           |
| **Cognito**     | `cognito_dart-auth-sdk`        | [pub.dev](https://pub.dev/packages/cognito_dart_auth_sdk)        | [github](https://github.com/aortem/cognito-dart-auth-sdk)         |
| **EntraId**     | `entra-id-dart-auth-sdk`       | [pub.dev](https://pub.dev/packages/entra_id_dart_auth_sdk)       | [github](https://github.com/aortem/entra-id-dart-auth-sdk)        |
| **Fingerprint** | `fingerprint_dart-auth-sdk`    | [pub.dev](https://pub.dev/packages/fingerprint_dart_auth_sdk)    | [github](https://github.com/aortem/fingerprint-dart-auth-sdk)     |
| **Firebase**    | `firebase_dart_admin_auth_sdk` | [pub.dev](https://pub.dev/packages/firebase_dart_admin_auth_sdk) | [github](https://github.com/aortem/firebase-dart-admin-auth-sdk)  |
| **Magic**       | `magic_dart-auth-sdk`          | [pub.dev](https://pub.dev/packages/magic_dart_auth_sdk)          | [github](https://github.com/aortem/magic-dart-auth-sdk)           |
| **Okta**        | `okta_dart-auth-sdk`           | [pub.dev](https://pub.dev/packages/okta_identity_dart_auth_sdk)  | [github](https://github.com/aortem/okta-identity-dart-auth-sdk)   |
| **Ping**        | `ping_dart-auth-sdk`           | [pub.dev](https://pub.dev/packages/ping_identity_dart_auth_sdk)  | [github](https://github.com/aortem/ping-identity-dart-auth-sdk)   |
| **Stytch**      | `stytch_dart-auth-sdk`         | [pub.dev](https://pub.dev/packages/stytch_dart_auth_sdk)         | [github](https://github.com/aortem/stytch-dart-auth-sdk)          |
| **Transmit**    | `transmit_dart-auth-sdk`       | [pub.dev](https://pub.dev/packages/transmit_dart_auth_sdk)       | [github](https://github.com/aortem/transmit-dart-auth-sdk)        |

---

## Package Conflicts and Aliases

In some cases, core dart package have naming conflicts (ie. same method, classname).  For some packages, we build wrappers and use the DS prefix to avoid those conflicts.  

In other cases, where may avoid using a package altogether.  We will keep the documentation up to date as often as possible.

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!