import 'package:firebase_dart_admin_auth_sdk/firebase_dart_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('FirebaseAuth', () {
    late FirebaseAuth auth;

    setUp(() {
      auth = FirebaseAuth(apiKey: 'test-api-key', projectId: 'test-project-id');
    });

    test('signInWithEmailAndPassword succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('signInWithPassword'));
        return http.Response(
          '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"testUid","email":"test@example.com","displayName":"","idToken":"testIdToken","registered":true,"refreshToken":"testRefreshToken","expiresIn":"3600"}',
          200,
        );
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      final result =
          await auth.signInWithEmailAndPassword('test@example.com', 'password');
      expect(result.user.uid, equals('testUid'));
      expect(result.user.email, equals('test@example.com'));
    });

    test('signInWithEmailAndPassword fails', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('signInWithPassword'));
        return http.Response(
          '{"error":{"code":400,"message":"INVALID_PASSWORD","errors":[{"message":"INVALID_PASSWORD","domain":"global","reason":"invalid"}]}}',
          400,
        );
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      expect(
        () => auth.signInWithEmailAndPassword(
            'test@example.com', 'wrongpassword'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('createUserWithEmailAndPassword succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('signUp'));
        return http.Response(
          '{"kind":"identitytoolkit#SignupNewUserResponse","localId":"newTestUid","email":"newuser@example.com","idToken":"newTestIdToken","refreshToken":"newTestRefreshToken","expiresIn":"3600"}',
          200,
        );
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      final result = await auth.createUserWithEmailAndPassword(
          'newuser@example.com', 'password');
      expect(result.user.uid, equals('newTestUid'));
      expect(result.user.email, equals('newuser@example.com'));
    });

    test('signInWithCustomToken succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('signInWithCustomToken'));
        return http.Response(
          '{"kind":"identitytoolkit#VerifyCustomTokenResponse","localId":"customTokenUid","idToken":"customTokenIdToken","refreshToken":"customTokenRefreshToken","expiresIn":"3600"}',
          200,
        );
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      final result = await auth.signInWithCustomToken('custom_token');
      expect(result.user.uid, equals('customTokenUid'));
    });

    test('signInWithCredential (email/password) succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('signInWithPassword'));
        return http.Response(
          '{"kind":"identitytoolkit#VerifyPasswordResponse","localId":"credentialUid","email":"credential@example.com","displayName":"","idToken":"credentialIdToken","registered":true,"refreshToken":"credentialRefreshToken","expiresIn":"3600"}',
          200,
        );
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      final credential = EmailAuthCredential(
          email: 'credential@example.com', password: 'password');
      final result = await auth.signInWithCredential(credential);
      expect(result.user.uid, equals('credentialUid'));
      expect(result.user.email, equals('credential@example.com'));
    });

    test('sendSignInLinkToEmail succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('sendOobCode'));
        return http.Response('{}', 200);
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      final settings = acs.ActionCodeSettings(
        url: 'https://example.com/finishSignUp?cartId=1234',
        handleCodeInApp: true,
        //the parameters that are not defined:
        // iOSBundleId: 'com.example.ios',
        // androidPackageName: 'com.example.android',
        // androidInstallApp: true,
        // androidMinimumVersion: '12',
      );

      await expectLater(
          auth.sendSignInLinkToEmail('test@example.com', settings), completes);
    });

    test('signInWithEmailLink succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('signInWithEmailLink'));
        return http.Response(
          '{"kind":"identitytoolkit#EmailLinkSigninResponse","localId":"emailLinkUid","email":"emaillink@example.com","idToken":"emailLinkIdToken","refreshToken":"emailLinkRefreshToken","expiresIn":"3600"}',
          200,
        );
      });

      auth = FirebaseAuth(
          apiKey: 'test-api-key',
          projectId: 'test-project-id',
          httpClient: client);

      final result = await auth.signInWithEmailLink(
          'emaillink@example.com', 'https://example.com?oobCode=abc123');
      expect(result.user.uid, equals('emailLinkUid'));
      expect(result.user.email, equals('emaillink@example.com'));
    });
  });
}
