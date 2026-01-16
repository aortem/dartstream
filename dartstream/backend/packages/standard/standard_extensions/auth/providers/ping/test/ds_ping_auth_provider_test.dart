import 'package:test/test.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ping_identity_dart_auth_sdk/ds_ping_auth_export.dart';

void main() {
  late DSAuthManager authManager;

  setUp(() async {
    DSAuthManager.clearProviders();

    DSAuthManager.registerProvider(
      'ping',
      DSPingAuthProvider(),
      DSAuthProviderMetadata(
        type: 'ping',
        region: 'mock',
        clientId: 'mock-client-id',
      ),
    );

    authManager = DSAuthManager('ping');
  });

  tearDown(() {
    DSAuthManager.clearProviders();
  });

  test('Ping: create account success', () async {
    await authManager.createAccount(
      'user@ping.com',
      'password123',
      displayName: 'Ping User',
    );

    await authManager.signIn('user@ping.com', 'password123');

    final user = await authManager.getCurrentUser();

    expect(user.email, 'user@ping.com');
    expect(user.displayName, 'Ping User');
    expect(user.id.isNotEmpty, true);
  });

  test('Ping: duplicate account throws error', () async {
    await authManager.createAccount(
      'duplicate@ping.com',
      'password123',
    );

    expect(
      () => authManager.createAccount(
        'duplicate@ping.com',
        'password123',
      ),
      throwsA(isA<DSAuthError>()),
    );
  });

  test('Ping: sign in with invalid credentials fails', () async {
    await authManager.createAccount(
      'fail@ping.com',
      'password123',
    );

    expect(
      () => authManager.signIn('fail@ping.com', 'wrong-password'),
      throwsA(isA<DSAuthError>()),
    );
  });

  test('Ping: sign out clears session', () async {
    await authManager.createAccount(
      'logout@ping.com',
      'password123',
    );

    await authManager.signIn('logout@ping.com', 'password123');

    await authManager.signOut();

    expect(
      () => authManager.getCurrentUser(),
      throwsA(isA<DSAuthError>()),
    );
  });

  test('Ping: token verification success', () async {
    await authManager.createAccount(
      'token@ping.com',
      'password123',
    );

    await authManager.signIn('token@ping.com', 'password123');

    final isValid = await authManager.verifyToken('mock-access-token-${(await authManager.getCurrentUser()).id}');
    expect(isValid, true);
  });

  test('Ping: token verification fails with invalid token', () async {
    final isValid = await authManager.verifyToken('invalid-token');
    expect(isValid, false);
  });

  test('Ping: refresh token returns new access token', () async {
    await authManager.createAccount(
      'refresh@ping.com',
      'password123',
    );

    await authManager.signIn('refresh@ping.com', 'password123');

    final newToken = await authManager.refreshToken(
      'mock-refresh-token-${(await authManager.getCurrentUser()).id}',
    );

    expect(newToken.isNotEmpty, true);
  });

  test('Ping: get user by id', () async {
    await authManager.createAccount(
      'lookup@ping.com',
      'password123',
    );

    await authManager.signIn('lookup@ping.com', 'password123');

    final currentUser = await authManager.getCurrentUser();
    final fetchedUser = await authManager.getUser(currentUser.id);

    expect(fetchedUser.email, currentUser.email);
    expect(fetchedUser.id, currentUser.id);
  });
}
