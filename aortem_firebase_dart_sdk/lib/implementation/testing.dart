import 'package:aortem_firebase_dart_sdk/core.dart';
import 'package:aortem_firebase_dart_sdk/implementation/pure_dart.dart';
import 'package:aortem_firebase_dart_sdk/src/auth/app_verifier.dart';
import 'package:aortem_firebase_dart_sdk/src/auth/backend/backend.dart' as auth;
import 'package:aortem_firebase_dart_sdk/src/implementation/testing.dart';
// import 'package:aortem_firebase_dart_sdk/src/storage/backend/backend.dart' as storage;
import 'package:aortem_firebase_dart_sdk/src/implementation/testing_no_isolate.dart'
    if (dart.library.isolate) 'package:aortem_firebase_dart_sdk/src/implementation/testing_isolate.dart';

export 'package:aortem_firebase_dart_sdk/src/auth/backend/backend.dart'
    show BackendUser;

class FirebaseTesting {
  /// Initializes the pure dart firebase implementation for testing purposes.
  static Future<void> setup({bool isolated = false}) async {
    FirebaseDart.setup(
      isolated: isolated,
      platform: Platform.web(
          currentUrl: 'http://localhost', isMobile: true, isOnline: true),
      applicationVerifier: DummyApplicationVerifier(),
      httpClient: createHttpClient(),
    );
  }

  // static Backend getBackend(FirebaseOptions options) => BackendImpl(options);
}

abstract class Backend {
  auth.AuthBackend get authBackend;
  // storage.StorageBackend get storageBackend;
}
