import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ping_identity_dart_auth_sdk/ds_ping_auth_export.dart';

void main() async {
  DSAuthManager.enableDebugging = true;

  DSAuthManager.registerProvider(
    'ping',
    DSPingAuthProvider(),
    DSAuthProviderMetadata(
      type: 'ping',
      region: 'mock',
      clientId: 'example-client',
    ),
  );

  final auth = DSAuthManager('ping');

  await auth.createAccount(
    'example@ping.com',
    'password123',
    displayName: 'Ping Example',
  );

  await auth.signIn('example@ping.com', 'password123');

  final user = await auth.getCurrentUser();
  print('Signed in as: ${user.email}');

  final tokenValid = await auth.verifyToken(
    'mock-access-token-${user.id}',
  );
  print('Token valid: $tokenValid');

  await auth.signOut();
  print('Signed out');
}
