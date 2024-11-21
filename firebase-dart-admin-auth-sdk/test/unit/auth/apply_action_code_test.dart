// ignore_for_file: depend_on_referenced_packages

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('FirebaseAuth Tests - Using Typed Arguments', () {
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test('performRequest with specific typed arguments', () async {
      // Arrange: Mock performRequest for a specific endpoint and body
      const endpoint = 'update';
      const body = {'key': 'value'};
      final expectedResponse = HttpResponse(
        statusCode: 200,
        body: {'message': 'Success'},
      );

      // Properly mock the performRequest method to return a Future<HttpResponse>
      when(mockFirebaseAuth.performRequest(endpoint, body)).thenAnswer(
        (_) async => expectedResponse,
      );

      // Act: Call performRequest with specific arguments
      final result = await mockFirebaseAuth.performRequest(endpoint, body);

      // Assert: Verify the response matches
      expect(result.statusCode, equals(200));
      expect(result.body, containsPair('message', 'Success'));

      // Verify performRequest was called once with the exact arguments
      verify(mockFirebaseAuth.performRequest(endpoint, body)).called(1);
    });
  });
}
