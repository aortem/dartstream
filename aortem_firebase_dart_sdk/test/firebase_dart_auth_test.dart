import 'package:aortem_firebase_dart_sdk/firebase_dart_auth.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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

    // Add more tests for other methods
  });
}
