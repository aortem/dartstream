import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/firebase_auth_mock.dart';

void main() {
  group('FirebaseAuth Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test('performRequest handles typed arguments correctly', () async {
      // Arrange
      const endpoint = 'update';
      const body = {'key': 'value'};
      final expectedResponse = HttpResponse(
        statusCode: 200,
        body: {'message': 'Success'},
      );

      when(mockFirebaseAuth.performRequest(endpoint, body))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await mockFirebaseAuth.performRequest(endpoint, body);

      // Assert
      expect(result.statusCode, equals(200));
      expect(result.body, containsPair('message', 'Success'));

      verify(mockFirebaseAuth.performRequest(endpoint, body)).called(1);
    });
  });
}
