import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:firebase_dart_admin_auth_sdk/src/platform/other.dart'
    if (dart.library.html) 'package:firebase_dart_admin_auth_sdk/src/platform/web.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;

//import 'package:mockito/mockito.dart'; // Import mockito

class MockClient extends Mock implements http.Client {}

FirebaseAuth? auth; // Declare auth outside of the main function
void main() async {
  setUpAll(() async {
    // Register mock values
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
  });

  // tearDown(() {
  //   // Code to clean up after each test
  //   auth = null; // Reset auth to null after each test to avoid side effects
  // });

  tearDownAll(() async {
    // Code to clean up after all tests are completed
    auth?.dispose(); // Dispose the auth instance to clean up resources
  });

  final fakeServiceAccountJson = '''
      {
        "type": "service_account",
        "project_id": "mock-project-id",
        "private_key_id": "mock-private-key-id",
        "private_key": "-----BEGIN PRIVATE KEY-----\\nmock-private-key\\n-----END PRIVATE KEY-----\\n",
        "client_email": "mock-client-email@mock-project-id.iam.gserviceaccount.com",
        "client_id": "mock-client-id",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/mock-client-email"
      }
      ''';

  final firebaseAppIntializationMethods = {
    'enviroment_variables': () async =>
        FirebaseApp.initializeAppWithEnvironmentVariables(
          apiKey: 'FIREBASE_API_KEY',
          projectId: 'FIREBASE_PROJECT_ID',
          bucketName: 'FIREBASE_STORAGE_BUCKET_NAME',
        ),
    'service_account': () => FirebaseApp.initializeAppWithServiceAccount(
          serviceAccountContent: fakeServiceAccountJson,
          serviceAccountKeyFilePath: '../test.json',
        ),
    'service_account_impersonation': () async =>
        FirebaseApp.initializeAppWithServiceAccountImpersonation(
          serviceAccountEmail:
              'your-service-account-email@your-project-id.iam.gserviceaccount.com',
          userEmail: 'your-user-email@example.com',
        ),
  };
  //FirebaseAuth? auth;
  for (var element in firebaseAppIntializationMethods.entries) {
    MockClient mockClient = MockClient();

    test('set up method', () async {
      final app = await element.value();
      auth = app.getAuth();

      auth?.httpClient = mockClient;
    });

    test(
      '${element.key} signInWithEmailAndPassword succeeds',
      () async {
        // Mocking the HTTP response for a successful sign-in with email and password.
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                  200,
                ));

        final result = await auth?.signInWithEmailAndPassword(
          'test@example.com',
          'password',
        );

        // Verify that the post method on the mock client was called
        verify(() => mockClient.post(any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'))).called(1);

        expect(result?.user.uid, equals('testUid'));
        expect(result?.user.email, equals('test@example.com'));
        // Ensure no real network requests were made
        verifyNoMoreInteractions(mockClient);
      },
    );

    test('signInWithEmailAndPassword fails', () async {
      // Mocking the HTTP response for a failed sign-in with email and password.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"error":{"code":400,"message":"INVALID_PASSWORD","errors":[{"message":"INVALID_PASSWORD","domain":"global","reason":"invalid"}]}}',
                400,
              ));

      expect(
        () => auth?.signInWithEmailAndPassword(
            'test@example.com', 'wrongpassword'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('createUserWithEmailAndPassword succeeds', () async {
      // Mocking the HTTP response for a successful user creation with email and password.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#SignupNewUserResponse","localId":"newTestUid","email":"newuser@example.com","idToken":"newTestIdToken","refreshToken":"newTestRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.createUserWithEmailAndPassword(
          'newuser@example.com', 'password');
      expect(result?.user.uid, equals('newTestUid'));
      expect(result!.user.email!, equals('newuser@example.com'));
    });

    test('signInWithCustomToken succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with custom token.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyCustomTokenResponse","localId":"customTokenUid","idToken":"customTokenIdToken","refreshToken":"customTokenRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.signInWithCustomToken('custom_token');
      expect(result?.user.uid, equals('customTokenUid'));
    });

    test('signInWithCredential (email/password) succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with credential (email/password).
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"credentialUid","email":"credential@example.com","displayName":"","idToken":"credentialIdToken","registered":true,"refreshToken":"credentialRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final credential = EmailAuthCredential(
          email: 'credential@example.com', password: 'password');
      await auth?.signInWithCredential(credential);

      // Check for side effects or state changes instead of directly assuming the user.
      final user = auth?.currentUser;
      expect(user, isNotNull); // Ensure the user is not null
      expect(user!.uid, equals('credentialUid'));
      expect(user.email, equals('credential@example.com'));
    });

    test('sendSignInLinkToEmail succeeds', () async {
      // Mocking the HTTP response for a successful send sign-in link to email.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      final settings = acs.ActionCodeSettings(
        url: 'https://example.com/finishSignUp?cartId=1234',
        handleCodeInApp: true,
      );

      await expectLater(
        auth?.sendSignInLinkToEmail('test@example.com', settings),
        completes,
      );
    });

    test('signInWithEmailLink succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with email link.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#EmailLinkSigninResponse","localId":"emailLinkUid","email":"emaillink@example.com","idToken":"emailLinkIdToken","refreshToken":"emailLinkRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.signInWithEmailLink(
        'emaillink@example.com',
        'https://example.com?oobCode=abc123',
      );
      expect(result?.user.uid, equals('emailLinkUid'));
      expect(result?.user.email, equals('emaillink@example.com'));
    });

    test('updateCurrentUser succeeds', () async {
      // Mocking the HTTP response for a successful update of current user.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      await expectLater(
          auth?.updateUserInformation(
              'testUid', 'testTokden', {'displayName': 'Updated User'}),
          completes);
    });

    test('useDeviceLanguage succeeds', () async {
      // Mocking the HTTP response for a successful use of device language.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      await expectLater(
          auth?.deviceLanguage(
            'testUid',
          ),
          completes);
    });

    test('verifyPasswordResetCode succeeds', () async {
      // Mocking the HTTP response for a successful verification of password reset code.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"email": "test@example.com"}',
                200,
              ));

      final result = await auth?.verifyPasswordResetCode('test-code');
      expect(result?.body['email'], equals('test@example.com'));
    });

    test('signInWithRedirect succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with redirect.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"redirectUid","email":"redirect@example.com","displayName":"","idToken":"redirectIdToken","registered":true,"refreshToken":"redirectRefreshToken","expiresIn":"3600"}',
                200,
              ));

      if (isRunningOnWeb()) {
        await auth?.signInWithRedirect('providerId');
        // Instead of checking a result, verifying that the authentication state has changed.
        // You can check the currentUser property or listen to an auth state change stream.
        expect(auth?.currentUser,
            isNotNull); // Assuming the sign-in was successful and a user is now signed in.

        // Alternatively, listen to the auth state change stream if applicable.
        auth?.onAuthStateChanged().listen(expectAsync1((user) {
          expect(user, isNotNull); // Verifies that the user is not null.
          // Additional checks can be added based on the expected state of the user.
        }));
      } else {
        expectLater(
          () async => await auth?.signInWithRedirect('providerId'),
          throwsA(isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'sign-in-redirect-error',
          )),
        );
      }
    });

    test('should apply action code if FirebaseApp is initialized', () async {
      when(() => mockClient.post(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
            '{ "email": "user@example.com","requestType": "VERIFY_EMAIL"}',
            200),
      );

      final result = await auth?.applyActionCode('action_code');

      expect(true, result);
    });

    test('should send verification code to user', () async {
      when(() => mockClient.post(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
            '{ "email": "user@example.com","requestType": "VERIFY_EMAIL"}',
            200),
      );

      expectLater(auth?.sendEmailVerificationCode(), completes);
    });

    test('reload user  succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with email and password.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"users":[{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}]}',
                200,
              ));

      final result = await auth?.reloadUser();
      expect(result?.uid, equals('testUid'));
      expect(result?.email, equals('test@example.com'));
    });

    test('set language code succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with email and password.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.setLanguageCode('ENG');
      expect(result?.uid, equals('testUid'));
      expect(result?.email, equals('test@example.com'));
    });

    test('Update password succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with email and password.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.updatePassword('12345678');
      expect(result?.uid, equals('testUid'));
      expect(result?.email, equals('test@example.com'));
    });

    test('unlink provider succeeds', () async {
      // Mocking the HTTP response for a successful sign-in with email and password.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.unlinkProvider('google.com');
      expect(result?.uid, equals('testUid'));
      expect(result?.email, equals('test@example.com'));
    });

    // Test for sendPasswordResetEmail
    test('sendPasswordResetEmail succeeds', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      await expectLater(
        auth?.sendPasswordResetEmail('test@example.com'),
        completes,
      );
    });

    // Test for revokeAccessToken
    test('revokeAccessToken succeeds', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      expectLater(
        auth?.revokeToken('testIdToken'),
        completes,
      );
    });

    // Test for onIdTokenChanged
    test(
      'onIdTokenChanged emits user',
      () async {
        final user = User(
          uid: 'testUid',
          email: 'test@example.com',
          emailVerified: false,
          phoneNumber: null,
          displayName: '',
          photoURL: null,
          idToken: 'testIdToken',
        );

        Future.delayed(Duration(milliseconds: 100))
            .then((_) => auth?.updateCurrentUser(user));

        await expectLater(
          auth?.onIdTokenChanged(),
          emitsInOrder([user]),
        );
      },
    );

    // Test for onAuthStateChanged
    test(
      'onAuthStateChanged emits user',
      () async {
        final expectedUser = User(
          uid: 'testUid',
          email: 'test@example.com',
          emailVerified: false,
          phoneNumber: null,
          displayName: '',
          photoURL: null,
          idToken: 'testIdToken',
        );

        Future.delayed(Duration(milliseconds: 100))
            .then((_) => auth?.updateCurrentUser(expectedUser));

        await expectLater(
          auth?.onAuthStateChanged(),
          emitsInOrder([expectedUser]),
        );
      },
    );

    // Test for isSignInWithEmailLink
    test('signInWithEmailAndPassword succeeds', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                200,
              ));

      final result = await auth?.signInWithEmailAndPassword(
          'test@example.com', 'password');
      expect(result?.user.uid, equals('testUid'));
      expect(result?.user.email, equals('test@example.com'));
    });

    // Additional tests for methods:

    test('sendPasswordResetEmail succeeds', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{}',
                200,
              ));

      await auth?.sendPasswordResetEmail('test@example.com');
    });

    test('revokeToken succeeds', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{}',
                200,
              ));

      await auth?.revokeToken('testIdToken');
    });

    test('linkWithCredential succeeds with EmailAuthCredential', () async {
      when(() => mockClient.post(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(
          '{"localId":"testUid","idToken":"newIdToken"}',
          200,
        ),
      );

      final credential =
          EmailAuthCredential(email: 'test@example.com', password: 'password');
      final result = await auth?.linkWithCredential(credential);

      expect(result?.user.idToken, equals('newIdToken'));
    });

    test('parseActionCodeUrl returns parsed parameters', () async {
      final result = await auth?.parseActionCodeUrl(
          'https://example.com/?mode=resetPassword&oobCode=CODE&lang=en');
      expect(result['mode'], equals('resetPassword'));
      expect(result['oobCode'], equals('CODE'));
      expect(result['lang'], equals('en'));
    });

    test('firebasePhoneNumberLinkMethod sends verification code', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{}',
                200,
              ));

      if (isRunningOnWeb()) {
        expectLater(
            auth?.firebasePhoneNumberLinkMethod('+1234567890'), completes);
      } else {
        expectLater(
          () async => await auth?.firebasePhoneNumberLinkMethod('+1234567890'),
          throwsA(isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'verification-code-error',
          )),
        );
      }
    });

    test('getIdToken returns token', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"idToken":"testIdToken"}',
                200,
              ));

      //final token = await auth.getIdToken();
      expectLater(auth?.getIdToken(), completes);
    });

    test('getIdTokenResult returns token result', () async {
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                '{"idToken":"testIdToken","claims":{"admin":true}}',
                200,
              ));

      expectLater(auth?.getIdTokenResult(), completes);
    });

    test('signOut succeeds', () async {
      // Mocking the HTTP response for a successful sign-out.
      when(() => mockClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      await auth?.signOut();
      expect(auth?.currentUser, isNull);
    });

    group('delete account test', () {
      setUp(
        () async {
          mockClient.close();
          mockClient = MockClient();

          auth?.updateCurrentUser(User(uid: 'testUid'));
        },
      );
      test('deleteFirebaseUser succeeds', () async {
        when(() => mockClient.delete(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{}',
                  200,
                ));

        expectLater(auth?.deleteFirebaseUser(), completes);
      });
    });
  }
  // Test for dispose
  test('dispose closes streams', () async {
    auth?.dispose();
    await expectLater(auth?.onIdTokenChanged().isEmpty, completion(isTrue));
    await expectLater(auth?.onAuthStateChanged().isEmpty, completion(isTrue));
  });
}
