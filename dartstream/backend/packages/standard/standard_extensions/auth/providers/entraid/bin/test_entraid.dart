import '../lib/ds_entraid_auth_provider.dart';

Future<void> main() async {
  final auth = DSEntraIDAuthProvider(
    tenantId: 'test-tenant',
    clientId: 'test-client',
    clientSecret: 'test-secret',
  );

  await auth.initialize({});

  // Create user
  await auth.createAccount(
    'test@example.com',
    'password123',
    displayName: 'Test User',
  );

  // Sign in
  await auth.signIn('test@example.com', 'password123');

  final user = await auth.getCurrentUser();
  print('Current user: ${user.email}');

  // Verify token
  final isValid = await auth.verifyToken();
  print('Token valid: $isValid');

  // Sign out
  await auth.signOut();

  print('✅ EntraID mock auth test completed');
}
