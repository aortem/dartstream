import 'dart:async';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;

class MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
  });

  group('FirebaseApp', () {
    late FirebaseApp app;

    Future<void> initializeAppWithEnvironmentVariables() async {
      app = await FirebaseApp.initializeAppWithEnvironmentVariables(
        apiKey: 'FIREBASE_API_KEY',
        projectId: 'FIREBASE_PROJECT_ID',
      );
    }

    Future<void> initializeAppWithServiceAccount() async {
      app = await FirebaseApp.initializeAppWithServiceAccount(
        serviceAccountKeyFilePath:
            '/Users/user/Documents/GitLab/firebase-dart-admin-auth-sdk/firebase-dart-admin-auth-sdk/test.json',
      );
    }

    Future<void> initializeAppWithServiceAccountImpersonation() async {
      app = await FirebaseApp.initializeAppWithServiceAccountImpersonation(
        serviceAccountEmail:
            'your-service-account-email@your-project-id.iam.gserviceaccount.com',
        userEmail: 'your-user-email@example.com',
      );
    }

    group('FirebaseAuth', () {
      late FirebaseAuth auth;
      late MockClient mockClient;

      setUp(() async {
        mockClient = MockClient(); // Initializing the MockClient
        await initializeAppWithEnvironmentVariables();
        auth = app.getAuth();
      });

      // Test using Service Account with Keys
      group('Service Account with Keys', () {
        setUp(() async {
          await initializeAppWithServiceAccount();
        });

        // Insert all your tests here
        test('signInWithEmailAndPassword succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInWithEmailAndPassword(
              'test@example.com', 'password');
          expect(result.user.uid, equals('testUid'));
          expect(result.user.email, equals('test@example.com'));
        });

        // Other tests...
      });

      // Test using Environment Variables
      group('Environment Variables', () {
        setUp(initializeAppWithEnvironmentVariables);

        // Insert all your tests here
        test('signInWithEmailAndPassword succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInWithEmailAndPassword(
              'test@example.com', 'password');
          expect(result.user.uid, equals('testUid'));
          expect(result.user.email, equals('test@example.com'));
        });

        // Other tests...
      });

      // Test using Service Account without Key Impersonation
      group('Service Account without Key Impersonation', () {
        setUp(initializeAppWithServiceAccountImpersonation);

        // Insert all your tests here
        test('signInWithEmailAndPassword succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInWithEmailAndPassword(
              'test@example.com', 'password');
          expect(result.user.uid, equals('testUid'));
          expect(result.user.email, equals('test@example.com'));
        });

        // Other tests...
      });

      // Common tests for all configurations
      void runCommonTests() {
        test('signInWithEmailAndPassword fails', () async {
          // Mocking the HTTP response for a failed sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"error":{"code":400,"message":"INVALID_PASSWORD","errors":[{"message":"INVALID_PASSWORD","domain":"global","reason":"invalid"}]}}',
                    400,
                  ));

          expect(
            () => auth.signInWithEmailAndPassword(
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

          final result = await auth.createUserWithEmailAndPassword(
              'newuser@example.com', 'password');
          expect(result.user.uid, equals('newTestUid'));
          expect(result.user.email, equals('newuser@example.com'));
        });

        test('signInWithCustomToken succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with custom token.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyCustomTokenResponse","localId":"customTokenUid","idToken":"customTokenIdToken","refreshToken":"customTokenRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInWithCustomToken('custom_token');
          expect(result.user.uid, equals('customTokenUid'));
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
          final result = await auth.signInWithCredential(credential);
          expect(result.user.uid, equals('credentialUid'));
          expect(result.user.email, equals('credential@example.com'));
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
            auth.sendSignInLinkToEmail('test@example.com', settings),
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

          final result = await auth.signInWithEmailLink(
            'emaillink@example.com',
            'https://example.com?oobCode=abc123',
          );
          expect(result.user.uid, equals('emailLinkUid'));
          expect(result.user.email, equals('emaillink@example.com'));
        });

        test('signOut succeeds', () async {
          // Mocking the HTTP response for a successful sign-out.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          auth.updateCurrentUser(
              User(uid: 'testUid', email: 'test@example.com'));

          await expectLater(auth.signOut(), completes);
          expect(auth.currentUser, isNull);
        });

        test('updateCurrentUser succeeds', () async {
          // Mocking the HTTP response for a successful update of current user.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(
              auth.updateUserInformation(
                  'testUid', {'displayName': 'Updated User'}),
              completes);
        });

        test('useDeviceLanguage succeeds', () async {
          // Mocking the HTTP response for a successful use of device language.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(auth.deviceLanguage('testUid', 'en'), completes);
        });

        test('verifyPasswordResetCode succeeds', () async {
          // Mocking the HTTP response for a successful verification of password reset code.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"email": "test@example.com"}',
                    200,
                  ));

          final result = await auth.verifyPasswordResetCode('test-code');
          expect(result['email'], equals('test@example.com'));
        });

        test('signInWithRedirect succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with redirect.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"redirectUid","email":"redirect@example.com","displayName":"","idToken":"redirectIdToken","registered":true,"refreshToken":"redirectRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInWithRedirect('providerId');
          expect(result.user.uid, equals('redirectUid'));
          expect(result.user.email, equals('redirect@example.com'));
        });

        test('should apply action code if FirebaseApp is initialized',
            () async {
          when(() => mockClient.post(any(),
              body: any(named: 'body'),
              headers: any(named: 'headers'))).thenAnswer(
            (_) async => http.Response(
                '{ "email": "user@example.com","requestType": "VERIFY_EMAIL"}',
                200),
          );

          final result = await auth.applyActionCode('action_code');

          expect(true, result);
        });
      }

      // Running common tests for each configuration
      runCommonTests();

      // New tests added below for #16 to #21
      group('New tests', () {
        setUp(initializeAppWithServiceAccount);

        // Test for sendPasswordResetEmail
        test('sendPasswordResetEmail succeeds', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(
            auth.sendPasswordResetEmail('test@example.com'),
            completes,
          );
        });

        // Test for revokeAccessToken
        test('revokeAccessToken succeeds', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(
            auth.revokeAccessToken,
            completes,
          );
        });

        // Test for onIdTokenChanged
        test('onIdTokenChanged emits user', () async {
          final user = User(uid: 'testUid', email: 'test@example.com');
          auth.updateCurrentUser(user);

          expect(auth.onIdTokenChanged(), emits(user));
        });

        // Test for onAuthStateChanged
        test('onAuthStateChanged emits user', () async {
          final user = User(uid: 'testUid', email: 'test@example.com');
          auth.updateCurrentUser(user);

          expect(auth.onAuthStateChanged(), emits(user));
        });

        // Test for isSignInWithEmailLink
        test('isSignInWithEmailLink returns true for valid link', () {
          final validLink =
              'https://example.com/?mode=signIn&oobCode=abcdefghijklmnop';
          expect(auth.isSignInWithEmailLink(validLink), isTrue);
        });

        test('isSignInWithEmailLink returns false for invalid link', () {
          final invalidLink = 'https://example.com/';
          expect(auth.isSignInWithEmailLink(invalidLink), isFalse);
        });

        // Test for dispose
        test('dispose closes streams', () async {
          auth.dispose();
          await expectLater(
              auth.onIdTokenChanged().isEmpty, completion(isTrue));
          await expectLater(
              auth.onAuthStateChanged().isEmpty, completion(isTrue));
        });
      });
    });
  });
}
