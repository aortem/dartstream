import 'package:aortem_firebase_dart_sdk/aortem_firebase_dart_sdk.dart';
import 'package:test/test.dart';
import 'package:firebase_dart/firebase_dart.dart';

void main() {
  FirebaseAuthService? authService;
  FirebaseAuth? firebaseAuth; // FirebaseAuth instance

  const fakeApiKey = 'fake_api_key';
  const fakeAuthDomain = 'fake_auth_domain';
  const fakeProjectId = 'fake_project_id';
  const fakeStorageBucket = 'fake_storage_bucket';
  const fakeMessagingSenderId = 'fake_messaging_sender_id';
  const fakeAppId = 'fake_app_id';

  setUp(() async {
    // Initialize Firebase app
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: fakeApiKey,
        authDomain: fakeAuthDomain,
        projectId: fakeProjectId,
        storageBucket: fakeStorageBucket,
        messagingSenderId: fakeMessagingSenderId,
        appId: fakeAppId,
      ),
    );

    // Initialize FirebaseAuth instance
    firebaseAuth = FirebaseAuth.instance;

    // Initialize FirebaseAuthService instance
    authService = FirebaseAuthService();
  });

  group('FirebaseAuthService', () {
    test('signInWithPopup throws exception if FirebaseApp is not initialized',
        () async {
      // Delete initialized app to test uninitialized state
      await Firebase.apps.first.delete();

      // Initialize FirebaseAuth separately if not already done
      firebaseAuth ??= FirebaseAuth.instance;

      // Use GoogleAuthProvider to get auth provider
      final googleProvider = GoogleAuthProvider();

      // Perform the test with signInWithPopup
      expect(
        () async => await authService!.signInWithPopup(googleProvider),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'startSignInWithPhoneNumber throws exception if FirebaseApp is not initialized',
        () async {
      await Firebase.apps.first
          .delete(); // Delete initialized app to test uninitialized state

      expect(
        () async => await authService!.startSignInWithPhoneNumber(
          '1234567890',
          RecaptchaVerifier(
            container: 'recaptcha-container',
            auth: FirebaseAuth.instance,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'confirmSignInWithPhoneNumber throws exception if FirebaseApp is not initialized',
        () async {
      await Firebase.apps.first
          .delete(); // Delete initialized app to test uninitialized state

      ConfirmationResult fakeResult = FakeConfirmationResult();

      expect(
        () async => await authService!
            .confirmSignInWithPhoneNumber(fakeResult, '123456'),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'signInWithEmailLink throws exception if FirebaseApp is not initialized',
        () async {
      await Firebase.apps.first
          .delete(); // Delete initialized app to test uninitialized state

      expect(
        () async => await authService!.signInWithEmailLink(
            email: 'test@example.com', emailLink: 'fake_link'),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'signInWithCustomToken throws exception if FirebaseApp is not initialized',
        () async {
      await Firebase.apps.first
          .delete(); // Delete initialized app to test uninitialized state

      expect(
        () async => await authService!.signInWithCustomToken('fake_token'),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'signInWithCredential throws exception if FirebaseApp is not initialized',
        () async {
      await Firebase.apps.first
          .delete(); // Delete initialized app to test uninitialized state

      final fakeCredential = EmailAuthProvider.credential(
          email: 'test@example.com', password: 'password');
      expect(
        () async => await authService!.signInWithCredential(fakeCredential),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'signInWithEmailAndPassword throws exception if FirebaseApp is not initialized',
        () async {
      await Firebase.apps.first
          .delete(); // Delete initialized app to test uninitialized state

      expect(
        () async => await authService!
            .signInWithEmailAndPassword('test@example.com', 'password'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

class FakeConfirmationResult implements ConfirmationResult {
  @override
  final String verificationId = 'fake_verification_id';

  @override
  Future<UserCredential> confirm(String verificationCode) async {
    throw Exception('Not implemented');
  }
}
