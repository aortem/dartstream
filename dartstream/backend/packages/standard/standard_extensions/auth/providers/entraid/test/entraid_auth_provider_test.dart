import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_entraid_auth_provider/ds_entraid_auth_provider.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

void main() {
  late DSEntraIDAuthProvider auth;

  setUp(() async {
    auth = DSEntraIDAuthProvider(
      tenantId: 'test-tenant',
      clientId: 'test-client',
      clientSecret: 'test-secret',
    );
    await auth.initialize({});
  });

  test('creates account successfully', () async {
    await auth.createAccount('user@test.com', 'password');

    final user = await auth.getUser('entraid|user_test_com');
    expect(user.email, 'user@test.com');
  });

  test('signs in successfully with correct credentials', () async {
    await auth.createAccount('login@test.com', 'password');
    await auth.signIn('login@test.com', 'password');

    final user = await auth.getCurrentUser();
    expect(user.email, 'login@test.com');
  });

  test('fails sign in with wrong password', () async {
    await auth.createAccount('fail@test.com', 'password');

    expect(
      () => auth.signIn('fail@test.com', 'wrong'),
      throwsA(isA<DSAuthError>()),
    );
  });

  test('signs out correctly', () async {
    await auth.createAccount('logout@test.com', 'password');
    await auth.signIn('logout@test.com', 'password');

    await auth.signOut();

    expect(
      () => auth.getCurrentUser(),
      throwsA(isA<DSAuthError>()),
    );
  });

  test('verifies token correctly', () async {
    await auth.createAccount('token@test.com', 'password');
    await auth.signIn('token@test.com', 'password');

    final valid = await auth.verifyToken();
    expect(valid, true);
  });
}