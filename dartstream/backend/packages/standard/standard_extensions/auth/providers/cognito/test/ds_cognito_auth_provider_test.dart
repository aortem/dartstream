import 'package:test/test.dart';
import 'package:ds_cognito_auth_provider/ds_cognito_auth_export.dart';

void main() {
  late DSCognitoAuthProvider provider;

  setUp(() async {
    provider = DSCognitoAuthProvider(
      userPoolId: 'mock_pool',
      clientId: 'mock_client',
      region: 'us-east-1',
    );
    await provider.initialize({});
  });

  test('sign in success', () async {
    await provider.signIn('user@test.com', 'Password123!');
    final user = await provider.getCurrentUser();
    expect(user.email, 'user@test.com');
  });

  test('sign in fails with invalid email', () async {
    expect(
      () => provider.signIn('invalid', 'Password123!'),
      throwsA(isA<Exception>()),
    );
  });

  test('token verification works', () async {
    await provider.signIn('user@test.com', 'Password123!');
    final valid = await provider.verifyToken();
    expect(valid, true);
  });
}
