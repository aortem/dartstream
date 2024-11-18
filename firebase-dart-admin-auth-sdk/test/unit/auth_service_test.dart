import 'package:test/test.dart';
import 'package:firebase_dart_admin_auth_sdk/auth_service.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService(); // Initialize the service
    });

    test('Sign in with valid credentials', () async {
      final result =
          await authService.signIn('test@example.com', 'password123');
      expect(result, isNotNull);
      expect(result.token, isNotEmpty);
    });

    test('Sign in with invalid credentials throws exception', () async {
      expect(
        () async =>
            await authService.signIn('invalid@example.com', 'wrongpass'),
        throwsException,
      );
    });
  });
}
