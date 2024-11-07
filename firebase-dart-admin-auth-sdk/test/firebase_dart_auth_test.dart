import 'dart:async';
import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/generate_custom_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/get_access_token_with_generated_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/id_token_result_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;
import 'dart:convert';

import 'package:firebase_dart_admin_auth_sdk/src/service_account.dart';

import 'package:jwt_generator/src/token.dart';

//import 'package:mockito/mockito.dart'; // Import mockito
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockHttpClient extends Fake implements http.Client {
  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    if (url.toString().contains('accounts:delete')) {
      return Future.value(
          http.Response('{"success": true}', 200)); // Mock successful response
    }
    return Future.value(http.Response(
        '{"error": "Unauthorized"}', 401)); // Mock unauthorized response
  }
}

class MockClient extends Mock implements http.Client {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockIdTokenResult extends Mock implements IdTokenResult {}

class MockGenerateCustomToken extends GenerateCustomToken {
  @override
  Future<String> generateCustomToken(
      FcmTokenDto fcmToken, String privateKey) async {
    return 'Token Generated';
  }

  @override
  Future<String> generateServiceAccountJwt(
      ServiceAccount serviceAccount) async {
    return 'Service Account JWT';
  }

  @override
  Future<String> generateSignInJwt(ServiceAccount serviceAccount,
      {String? uid, Map<String, dynamic>? additionalClaims}) async {
    return 'Generated signed jwt';
  }
}

class MockGetAccessTokenWithGeneratedToken
    extends GetAccessTokenWithGeneratedToken {
  @override
  Future<String> getAccessTokenWithGeneratedToken(String jwt) async {
    return 'AccessToken';
  }
}

class AuthService {
  // Assuming this is how currentUser is defined
  User? currentUser;

  Future<String?> getIdToken() async {
    final user = currentUser;
    return await user
        ?.getIdToken(); // This should call getIdToken on the mock user
  }

  Future<IdTokenResult?> getIdTokenResult() async {
    final user = currentUser;
    return await user?.getIdTokenResult();
  }
}

//FirebaseAuth? auth;
// Declare auth outside of the main function
void main() async {
  late AuthService auths;
  late MockUser mockUser;
  late MockIdTokenResult mockIdTokenResult;

  setUp(() {
    mockUser = MockUser();
    auths = AuthService(); // Initialize the auth service
    auths.currentUser = mockUser;
    mockIdTokenResult =
        MockIdTokenResult(); // Set the currentUser to the mock user

    FirebaseApp.overrideInstanceForTesting(
      MockGetAccessTokenWithGeneratedToken(),
      MockGenerateCustomToken(),
    );
  });
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
    //auth?.dispose(); // Dispose the auth instance to clean up resources
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
          authdomain: 'FIREBASE_AUTH_DOMAIN',
          messagingSenderId: 'FIREBASE_MESSAGE_SENDER_ID',
          bucketName: 'FIREBASE_STORAGE_BUCKET_NAME',
          appId: 'FIREBASE_APP_ID',
        ),
    'service_account': () async => FirebaseApp.initializeAppWithServiceAccount(
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

  test(
    'Test initializeAppWithServiceAccount',
    () async {
      FirebaseApp.overrideInstanceForTesting(
        MockGetAccessTokenWithGeneratedToken(),
        MockGenerateCustomToken(),
      );
      final app = await FirebaseApp.initializeAppWithServiceAccount(
        serviceAccountContent: fakeServiceAccountJson,
        serviceAccountKeyFilePath: '../test.json',
      );
      final auth = app.getAuth();
      expect(auth.accessToken, 'AccessToken');
    },
  );
  //FirebaseAuth? auth;

  group('services test', () {
    for (var element in firebaseAppIntializationMethods.entries) {
      MockClient mockClient = MockClient();
      FirebaseAuth? auth;

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

      if (element.key == 'service_account') {
        test('${element.key}  signInWithCustomToken succeeds', () async {
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
      }

      test('${element.key} signInWithCredential (email/password) succeeds',
          () async {
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

        final settings = ActionCodeSettings(
          url: 'https://example.com/finishSignUp?cartId=1234',
          handleCodeInApp: true,
        );

        await expectLater(
          auth?.sendSignInLinkToEmail('test@example.com', actionCode: settings),
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
        // Mocking the HTTP response for a successful user creation with email and password.
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"kind":"identitytoolkit#signInWithIdp","requestUri": "http:localhost","providerId":"google.com","access_token":"newTestIdToken",}',
                  200,
                ));

        final result = await auth?.signInWithRedirect(
            'http:localhost', 'testIdToken', "google.com");
        print('result: $result');
      });

      test('should apply action code if FirebaseApp is initialized', () async {
        when(() => mockClient.post(any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response(
              '{ "email": "user@example.com","requestType": "VERIFY_EMAIL"}',
              200),
        );

        final result = await auth?.applyActionCode('action_code');

        expect(true, result);
      });

      test('should send verification code to user', () async {
        when(() => mockClient.post(any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'))).thenAnswer(
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

      //Test update profile
      test('update profile', () async {
        // Mocking the HTTP response for a successful sign-in with email and password.
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"drake","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600","photoUrl":"sampleimage"}',
                  200,
                ));

        final result = await auth?.updateProfile('drake', 'sampleimage');
        expect(result?.displayName, equals('drake'));
        expect(result?.photoURL, equals('sampleimage'));
      });

      //verify before email update
      test('verifyBeforeEmailUpdate', () async {
        // Mocking the HTTP response for a successful sign-in with email and password.
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response('{}', 200));

        expectLater(
            auth?.verifyBeforeEmailUpdate(
              'sample@example.com',
            ),
            completes);
      });

      //Get additional Info
      test(
        'Get additional Info',
        () async {
          // Mocking the HTTP response for a successful sign-in with email and password.
          when(() => mockClient.post(any(),
              body: any(named: 'body'),
              headers: any(named: 'headers'))).thenAnswer(
            (_) async => http.Response(
              '{"users":[{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"drake","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600","photoUrl":"sampleimage"}]}',
              200,
            ),
          );

          final result = await auth?.getAdditionalUserInfo();
          expect(result?.displayName, equals('drake'));
          expect(result?.photoURL, equals('sampleimage'));
        },
      );

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

      // Test For RevokeAccessToken
      test('revokeAccessToken succeeds', () async {
        // Mocking the HTTP response for a successful token revocation
        when(() => mockClient.post(
              any(),
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => http.Response(
              '{"kind": "identitytoolkit#RevokeAccessTokenResponse"}',
              200,
            ));

        // Ensure the current user is set
        auth?.updateCurrentUser(User(
          uid: 'testUid',
          idToken: 'testIdToken',
          refreshToken: 'testRefreshToken',
        ));

        // Call the method and expect it to complete without throwing an error
        await expectLater(
          auth?.revokeAccessToken('testIdToken'),
          completes,
        );

        // Verify that the post method was called with the correct parameters
        verify(() => mockClient.post(
              Uri.https('identitytoolkit.googleapis.com',
                  '/v1/accounts:revokeAccessToken'),
              body: jsonEncode({
                'idToken': 'testIdToken',
              }),
              headers: {
                'Content-Type': 'application/json',
              },
            )).called(1);

        // Verify that no more interactions with the mock client occurred
        verifyNoMoreInteractions(mockClient);
      });

      // Test for FirebaseAuth.checkActionCode
      test('checkActionCode succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"operation":"PASSWORD_RESET","data":{"email":"test@example.com"}}',
                  200,
                ));

        final result = await auth?.checkActionCode('testActionCode');
        expect(result?.operation, equals('PASSWORD_RESET'));
        expect(result?.data['email'], equals('test@example.com'));
      });

      // Test for FirebaseAuth.confirmPasswordReset
      test('confirmPasswordReset succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response('{}', 200));

        await expectLater(
          auth?.confirmPasswordReset('testOobCode', 'newPassword'),
          completes,
        );
      });

      // Test for FirebaseAuth.createUserWithEmailAndPassword
      test('createUserWithEmailAndPassword succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"kind":"identitytoolkit#SignupNewUserResponse","localId":"newTestUid","email":"newuser@example.com","idToken":"newTestIdToken","refreshToken":"newTestRefreshToken","expiresIn":"3600"}',
                  200,
                ));

        final result = await auth?.createUserWithEmailAndPassword(
            'newuser@example.com', 'password123');
        expect(result?.user.uid, equals('newTestUid'));
        expect(result?.user.email, equals('newuser@example.com'));
      });

      // Test for FirebaseAuth.fetchSignInMethodsForEmail
      test('fetchSignInMethodsForEmail succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"signinMethods":["password","google.com"]}',
                  200,
                ));

        final result =
            await auth?.fetchSignInMethodsForEmail('test@example.com');
        expect(result, contains('password'));
        expect(result, contains('google.com'));
      });

      // Test for FirebaseAuth.getRedirectResult
      test('getRedirectResult succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"user":{"localId":"testUid","email":"test@example.com"},"providerId":"google.com","operationType":"signIn"}',
                  200,
                ));

        final result = await auth?.getRedirectResult();
        expect(result, isA<Map<String, dynamic>>());
        expect(result?['user']?['localId'], equals('testUid'));
        expect(result?['user']?['email'], equals('test@example.com'));
        expect(result?['providerId'], equals('google.com'));
      });

      // Test for FirebaseAuth.initializeRecaptchaConfig
      test('initializeRecaptchaConfig succeeds', () async {
        if (isRunningOnWeb()) {
          when(() => mockClient.post(any(),
                  body: any(named: 'body'), headers: any(named: 'headers')))
              .thenAnswer((_) async => http.Response('{}', 200));

          await expectLater(
            auth?.initializeRecaptchaConfig('testSiteKey'),
            completes,
          );
        } else {
          expect(
            () => auth?.initializeRecaptchaConfig('testSiteKey'),
            throwsA(isA<UnimplementedError>()),
          );
        }
      });

      // Test for FirebaseAuth.isSignInWithEmailLink
      test('isSignInWithEmailLink returns true for valid link', () {
        final validLink =
            'https://example.com/__/auth/action?mode=signIn&oobCode=testCode&apiKey=testApiKey';
        expect(auth?.isSignInWithEmailLink(validLink), isTrue);
      });

      test('isSignInWithEmailLink returns false for invalid link', () {
        final invalidLink = 'https://example.com/invalid';
        expect(auth?.isSignInWithEmailLink(invalidLink), isFalse);
      });

      // 1. signInWithPopup tests
      test('signInWithPopup succeeds with Google provider', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'kind': 'identitytoolkit#SignInWithPopupResponse',
                    'localId': 'testUid',
                    'email': 'test@example.com',
                    'displayName': 'Test User',
                    'photoUrl': 'https://example.com/photo.jpg',
                    'providerId': 'google.com',
                    'idToken': 'testIdToken',
                    'refreshToken': 'testRefreshToken',
                    'expiresIn': '3600',
                    'additionalUserInfo': {
                      'providerId': 'google.com',
                      'isNewUser': false,
                      'profile': {
                        'name': 'Test User',
                        'email': 'test@example.com'
                      }
                    }
                  }),
                  200,
                ));

        final provider = GoogleAuthProvider();
        final result = await auth?.signInWithPopup(provider, 'test-client-id');

        expect(result?.user.uid, equals('testUid'));
        expect(result?.user.email, equals('test@example.com'));
        expect(result?.user.displayName, equals('Test User'));

        verify(() => mockClient.post(any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'))).called(1);
      });

      test('signInWithPopup fails with popup closed', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'error': {'code': 400, 'message': 'POPUP_CLOSED_BY_USER'}
                  }),
                  400,
                ));

        final provider = GoogleAuthProvider();
        expect(
          () => auth?.signInWithPopup(provider, 'test-client-id'),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              'popup-closed-by-user',
            ),
          ),
        );
      });

// 3. signInWithEmailLink tests
      test('signInWithEmailLink succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'kind': 'identitytoolkit#EmailLinkSigninResponse',
                    'localId': 'testUid',
                    'email': 'test@example.com',
                    'idToken': 'testIdToken',
                    'refreshToken': 'testRefreshToken',
                    'expiresIn': '3600',
                    'isNewUser': false
                  }),
                  200,
                ));

        final result = await auth?.signInWithEmailLink(
          'test@example.com',
          'https://example.com/?mode=signIn&oobCode=abc123',
        );

        expect(result?.user.uid, equals('testUid'));
        expect(result?.user.email, equals('test@example.com'));
      });

      test('signInWithEmailLink handles invalid link', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'error': {'code': 400, 'message': 'INVALID_OOB_CODE'}
                  }),
                  400,
                ));

        expect(
          () => auth?.signInWithEmailLink(
            'test@example.com',
            'invalid-link',
          ),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              'invalid-action-code',
            ),
          ),
        );
      });

// 4. signInWithCustomToken tests
      test('signInWithCustomToken succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'kind': 'identitytoolkit#VerifyCustomTokenResponse',
                    'localId': 'testUid',
                    'email': 'test@example.com',
                    'idToken': 'testIdToken',
                    'refreshToken': 'testRefreshToken',
                    'expiresIn': '3600'
                  }),
                  200,
                ));

        final result = await auth?.signInWithCustomToken('custom-token');
        expect(result?.user.uid, equals('testUid'));
        expect(result?.user.email, equals('test@example.com'));
      });

      test('signInWithCustomToken handles invalid token', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'error': {'code': 400, 'message': 'INVALID_CUSTOM_TOKEN'}
                  }),
                  400,
                ));

        expect(
          () => auth?.signInWithCustomToken('invalid-token'),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              'invalid-custom-token',
            ),
          ),
        );
      });

      // Test for getRedirectResult
      test('getRedirectResult with signed in user succeeds', () async {
        // Mock current user
        final mockUser = User(
          uid: 'testUid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          emailVerified: true,
          idToken: 'testIdToken',
        );

        // Set mock current user
        FirebaseApp.instance.setCurrentUser(mockUser);

        final result = await auth?.getRedirectResult();

        expect(result, isNotNull);
        expect(result?['user']['uid'], equals('testUid'));
        expect(result?['user']['email'], equals('test@example.com'));
        expect(result?['user']['displayName'], equals('Test User'));
        expect(result?['user']['idToken'], equals('testIdToken'));
        expect(result?['credential']['providerId'], equals('google.com'));
        expect(result?['operationType'], equals('signIn'));
      });

      test('getRedirectResult with no user returns null', () async {
        // Ensure no current user
        FirebaseApp.instance.setCurrentUser(null);

        final result = await auth?.getRedirectResult();
        expect(result, isNull);
      });

      test('getRedirectResult with user but no token throws', () async {
        // Mock user without token
        final mockUser = User(
          uid: 'testUid',
          email: 'test@example.com',
          idToken: null,
        );

        FirebaseApp.instance.setCurrentUser(mockUser);

        final result = await auth?.getRedirectResult();
        expect(result, isNull);
      });

      // Tests for signInWithPhoneNumber
      test('signInWithPhoneNumber succeeds', () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'sessionInfo': 'test-verification-id',
                    'phoneNumber': '+16505550101'
                  }),
                  200,
                ));

        final appVerifier = MockApplicationVerifier();

        final result =
            await auth?.signInWithPhoneNumber('+16505550101', appVerifier);

        expect(result, isA<ConfirmationResult>());
      });

      test('signInWithPhoneNumber throws FirebaseAuthException on error',
          () async {
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  jsonEncode({
                    'error': {'message': 'Invalid phone number'}
                  }),
                  400,
                ));

        final appVerifier = MockApplicationVerifier();

        expect(
          () => auth?.signInWithPhoneNumber('+16505550101', appVerifier),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              'phone-auth-error',
            ),
          ),
        );
      });

      test('linkWithCredential  succeeds', () async {
        // Mocking the HTTP response for a successful user creation with email and password.
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(
                  '{"kind":"identitytoolkit#signInWithIdp","requestUri": "http:localhost","providerId":"google.com","access_token":"newTestIdToken",}',
                  200,
                ));

        final result = await auth?.linkAccountWithCredientials(
            'http:localhost', 'testIdToken', "google.com");
        print('result: $result'); // Print the actual result for debugging
      });

      test('parseActionCodeUrl returns parsed parameters', () async {
        final result = await auth?.parseActionCodeUrl(
            'https://example.com/?mode=resetPassword&oobCode=CODE&lang=en');
        expect(result['mode'], equals('resetPassword'));
        expect(result['oobCode'], equals('CODE'));
        expect(result['lang'], equals('en'));
      });

      test('getIdToken', () async {
        // Arrange
        when(() => mockUser.getIdToken())
            .thenAnswer((_) async => 'testIdToken');

        // Act
        final token = await auths.getIdToken();

        // Debugging information
        print('Token: $token'); // Print the actual token for debugging

        // Assert
        expect(token, 'testIdToken'); // Check that the token is as expected
        verify(() => mockUser.getIdToken())
            .called(1); // Verify that getIdToken was called once
      });
      test('getIdTokenResult ', () async {
        // Arrange
        when(() => mockUser.getIdTokenResult())
            .thenAnswer((_) async => mockIdTokenResult);

        // Act
        final result = await auths.getIdTokenResult();

        // Debugging information
        print(
            'IdTokenResult: $result'); // Print the actual result for debugging

        // Assert
        expect(
            result, mockIdTokenResult); // Check that the result is as expected
        verify(() => mockUser.getIdTokenResult())
            .called(1); // Verify that getIdTokenResult was called once
      });

      test('signOut succeeds', () async {
        // Sign in a user first
        auth?.updateCurrentUser(User(uid: 'testUid'));

        // Mocking the HTTP response for a successful sign-out.
        when(() => mockClient.post(any(),
                body: any(named: 'body'), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response('{}', 200));

        await auth?.signOut();
        expect(auth?.currentUser, isNull);
      });

      // Test for dispose on the last GCP method
      if (element.key == 'service_account_impersonation') {
        test('dispose closes streams', () async {
          auth?.dispose();
          await expectLater(
              auth?.onIdTokenChanged().isEmpty, completion(isTrue));
          await expectLater(
              auth?.onAuthStateChanged().isEmpty, completion(isTrue));
        });
      }

      tearDownAll(() {
        auth = null;
      });
    }
  });

  group('deleteUser', () {
    test('should delete user and return 200 status', () async {
      final mockHttpClient = MockHttpClient();

      // Your user instance
      final user = User(uid: 'sampleUid', idToken: 'sampleIdToken');

      // The deleteUser function we defined above
      Future<void> deleteUser(User user) async {
        final idToken = user.idToken;

        if (idToken == null || idToken.isEmpty) {
          print('Error: ID Token is null or empty.');
          return;
        }

        final response = await mockHttpClient.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=YOUR_FIREBASE_WEB_API_KEY'),
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'idToken': idToken,
          }),
        );

        if (response.statusCode == 200) {
          print('User successfully deleted');
        } else {
          print(
              'Error deleting user: ${response.statusCode} - ${response.body}');
        }
      }

      await deleteUser(user);
    });
  });
}
