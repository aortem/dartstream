import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/apply_action_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart'; // Assuming this exists

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('ApplyActionCode', () {
    late MockFirebaseAuth mockAuth;
    late ApplyActionCode applyActionCode;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      applyActionCode = ApplyActionCode(mockAuth);
    });

    test('should return true when action code is applied successfully',
        () async {
      const actionCode = 'valid-action-code';
      final dummyResponse = HttpResponse(
        statusCode: 200,
        body: {'message': 'Success'}, // Correct type
      );

      // Mock successful response
      when(mockAuth.performRequest('update', {'oobCode': actionCode}))
          .thenAnswer((_) => Future.value(dummyResponse));

      final result = await applyActionCode.applyActionCode(actionCode);

      expect(result, isTrue);
      verify(mockAuth.performRequest('update', {'oobCode': actionCode}))
          .called(1);
    });

    test(
        'should throw FirebaseAuthException when action code application fails',
        () async {
      const actionCode = 'invalid-action-code';

      // Mock failure
      when(mockAuth.performRequest('update', {'oobCode': actionCode}))
          .thenThrow(Exception('Network error'));

      expect(
        () async => await applyActionCode.applyActionCode(actionCode),
        throwsA(isA<FirebaseAuthException>()),
      );

      verify(mockAuth.performRequest('update', {'oobCode': actionCode}))
          .called(1);
    });
  });
}
