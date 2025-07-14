# ds_auth_firebase

Firebase Authentication provider for [DartStream](https://github.com/aortem/dartstream).

A drop-in `DSAuthProvider` implementation that uses the 
[`firebase_dart_admin_auth_sdk`](https://pub.dev/packages/firebase_dart_admin_auth_sdk) 
to support Email/Password, token verification, session handling, and more.

## Installation

```bash
dart pub add ds_auth_firebase
````

## Quick Start

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_auth_firebase/ds_auth_firebase_export.dart';

void main() async {
  // 1. Register the Firebase provider
  DSAuthManager.registerProvider(
    'firebase',
    DSFirebaseAuthProvider(
      projectId: 'your-project-id',
      privateKeyPath: 'path/to/service-account.json',
    ),
    DSAuthProviderMetadata(type: 'firebase'),
  );

  // 2. Initialize and use
  final auth = DSAuthManager('firebase');
  await auth.initialize({});
  await auth.signIn('user@example.com', 'password');
  print('Signed in: ${await auth.getCurrentUser()}');
}
```

## Key Features

* Implements all `DSAuthProvider` methods (`signIn`, `signOut`, `getCurrentUser`, etc.)
* Email/Password, password reset, email verification
* JWT token validation, refresh, and session tracking
* Unified error mapping to `DSAuthError`

## More Information

* 🔗 [API Reference](https://pub.dev/documentation/ds_auth_firebase/latest/)
* 🐛 [Issues & Roadmap](https://github.com/aortem/dartstream/issues)
* 📖 Full docs & examples on GitHub

---

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.

```