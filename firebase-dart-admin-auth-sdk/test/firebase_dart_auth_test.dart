import 'dart:async';
import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;
import 'package:firebase_dart_admin_auth_sdk/src/firebase_user/set_language_code.dart';

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
        serviceAccountContent: '',
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
          expect(result?.user.uid, equals('testUid'));
          expect(result?.user.email, equals('test@example.com'));
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
          expect(result?.user.uid, equals('testUid'));
          expect(result?.user.email, equals('test@example.com'));
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
          expect(result?.user.uid, equals('testUid'));
          expect(result?.user.email, equals('test@example.com'));
        });

        // Other tests...
      });

      // Common tests for all configurations
      void runCommonTests() {
        setUp(initializeAppWithServiceAccount);
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

          // await expectLater(
          //   auth.sendSignInLinkToEmail('test@example.com', settings),
          //   completes,
          // );
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
                  'testUid', 'testTokden', {'displayName': 'Updated User'}),
              completes);
        });

        test('useDeviceLanguage succeeds', () async {
          // Mocking the HTTP response for a successful use of device language.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(
              auth.deviceLanguage(
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

          final result = await auth.verifyPasswordResetCode('test-code');
          expect(result.body['email'], equals('test@example.com'));
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

        test('should send verification code to user', () async {
          await auth.sendEmailVerificationCode();

          expect(true, completes);
        });

        test('reload user  succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.reloadUser();
          expect(result.uid, equals('testUid'));
          expect(result.email, equals('test@example.com'));
        });

        test('set language code succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.setLanguageCode('ENG');
          expect(result.uid, equals('testUid'));
          expect(result.email, equals('test@example.com'));
        });

        test('Update password succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.updatePassword('12345678');
          expect(result.uid, equals('testUid'));
          expect(result.email, equals('test@example.com'));
        });

        test('unlink provider succeeds', () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.unlinkProvider('google.com');
          expect(result.uid, equals('testUid'));
          expect(result.email, equals('test@example.com'));
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
        test('signInWithEmailAndPassword succeeds', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInWithEmailAndPassword(
              'test@example.com', 'password');
          expect(result!.user.uid, equals('testUid'));
          expect(result.user.email, equals('test@example.com'));
        });

        // Additional tests for methods:

        test('sendPasswordResetEmail succeeds', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{}',
                    200,
                  ));

          await auth.sendPasswordResetEmail('test@example.com');
        });

        test('revokeToken succeeds', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{}',
                    200,
                  ));

          await auth.revokeToken('testIdToken');
        });

        test('linkWithCredential succeeds with EmailAuthCredential', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"idToken":"newIdToken"}',
                    200,
                  ));

          final credential = EmailAuthCredential(
              email: 'test@example.com', password: 'password');
          final result = await auth.linkWithCredential(credential);

          expect(result!.user.idToken, equals('newIdToken'));
        });

        test('parseActionCodeUrl returns parsed parameters', () async {
          final result = await auth.parseActionCodeUrl(
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

          await auth.firebasePhoneNumberLinkMethod('+1234567890');
        });

        test('deleteFirebaseUser succeeds', () async {
          when(() => mockClient.delete(any(), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{}',
                    200,
                  ));

          await auth.deleteFirebaseUser();
        });

        test('getIdToken returns token', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"idToken":"testIdToken"}',
                    200,
                  ));

          final token = await auth.getIdToken();
          expect(token, equals('testIdToken'));
        });

        test('getIdTokenResult returns token result', () async {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"idToken":"testIdToken","claims":{"admin":true}}',
                    200,
                  ));

          final tokenResult = await auth.getIdTokenResult();
        });
        // Test for dispose
        test('dispose closes streams', () async {
          auth.dispose();
          await expectLater(
              auth.onIdTokenChanged().isEmpty, completion(isTrue));
          await expectLater(
              auth.onAuthStateChanged().isEmpty, completion(isTrue));
        });

        //////////////////  test signInAnonymously////////////////

        test('signInAnonymously succeeds', () async {
          // Mocking the HTTP response for a successful anonymous sign-in.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"kind":"identitytoolkit#SignupNewUserResponse","localId":"anonUid","idToken":"anonIdToken","refreshToken":"anonRefreshToken","expiresIn":"3600"}',
                    200,
                  ));

          final result = await auth.signInAnonymouslyMethod();
          expect(result?.user.uid, equals('anonUid'));
          expect(result?.user.idToken, equals('anonIdToken'));
          expect(result?.user.refreshToken, equals('anonRefreshToken'));
          expect(result?.user.email, isNull);
        });

        test('signInAnonymously fails', () async {
          // Mocking the HTTP response for a failed anonymous sign-in.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"error":{"code":400,"message":"OPERATION_NOT_ALLOWED","errors":[{"message":"OPERATION_NOT_ALLOWED","domain":"global","reason":"invalid"}]}}',
                    400,
                  ));

          expect(
            () => auth.signInAnonymouslyMethod(),
            throwsA(isA<FirebaseAuthException>()),
          );
        }); ////////////////////////////test setPersistence

        test('setPersistence succeeds', () async {
          // Mocking the HTTP response for a successful set persistence.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(
            auth.setPresistanceMethod('local',
                'test-db-name'), // Replace 'local' with desired persistence type for the test
            completes,
          );
        });

        test('setPersistence fails with invalid API key', () async {
          // Mocking the HTTP response for a failed set persistence due to invalid API key.
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response(
                    '{"error":{"code":400,"message":"INVALID_API_KEY","errors":[{"message":"INVALID_API_KEY","domain":"global","reason":"invalid"}]}}',
                    400,
                  ));

          expect(
            () => auth.setPresistanceMethod('local',
                'test-db-name'), // Replace 'local' with desired persistence type for the test
            throwsA(isA<FirebaseAuthException>()),
          );
        });
      });
    });
    //////////////////////////
    group('LanguageService', () {
      late LanguageService languageService;
      late MockClient mockClient;

      setUp(() {
        mockClient = MockClient();
        languageService = LanguageService(auth: app.getAuth());
      });

      test('setLanguagePreference succeeds', () async {
        // Mocking the HTTP response for a successful language preference set.
        when(() => mockClient.patch(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response('{}', 200));

        await expectLater(
          languageService.setLanguagePreference(
              'test-user-id', 'test-id-token', 'en', 'test-db-name'),
          completes,
        );
      });

      test('setLanguagePreference fails with error', () async {
        // Mocking the HTTP response for a failed language preference set.
        when(() => mockClient.patch(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"error":{"code":400,"message":"FAILED_TO_SET_LANGUAGE"}}',
                  400,
                ));

        await expectLater(
          languageService.setLanguagePreference(
              'test-user-id', 'test-id-token', 'en', 'test-db-name'),
          completes,
        );
      });

      test('getLanguagePreference succeeds and retrieves language code',
          () async {
        // Mocking the HTTP response for a successful retrieval of language preference.
        final mockResponse = {
          "fields": {
            "languageCode": {"stringValue": "en"}
          }
        };

        when(() => mockClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
                (_) async => http.Response(jsonEncode(mockResponse), 200));

        final languageCode =
            await languageService.getLanguagePreference('test-user-id');

        expect(languageCode, 'en');
      });

      test('getLanguagePreference fails with error', () async {
        // Mocking the HTTP response for a failed retrieval of language preference.
        when(() => mockClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"error":{"code":404,"message":"USER_NOT_FOUND"}}',
                  404,
                ));

        final languageCode =
            await languageService.getLanguagePreference('test-user-id');

        expect(languageCode, isNull);
      });
    });
  });
}
