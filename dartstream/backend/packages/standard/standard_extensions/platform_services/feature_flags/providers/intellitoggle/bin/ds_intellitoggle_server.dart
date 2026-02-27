import 'dart:io';
import 'package:ds_intellitoggle_provider/ds_intellitoggle_export.dart';

/// Entry point for running the IntelliToggle provider as a server.
///
/// Reads OAuth2 credentials from environment variables and
/// initializes the IntelliToggle provider.
///
/// Required environment variables:
/// ```bash
/// INTELLITOGGLE_CLIENT_ID=your-client-id
/// INTELLITOGGLE_CLIENT_SECRET=your-client-secret
/// INTELLITOGGLE_TENANT_ID=your-tenant-id
/// INTELLITOGGLE_ENVIRONMENT=production # optional, defaults to production
/// ```
Future<void> main() async {
  final clientId = Platform.environment['INTELLITOGGLE_CLIENT_ID'];
  final clientSecret = Platform.environment['INTELLITOGGLE_CLIENT_SECRET'];
  final tenantId = Platform.environment['INTELLITOGGLE_TENANT_ID'];
  final environment =
      Platform.environment['INTELLITOGGLE_ENVIRONMENT'] ?? 'production';

  if (clientId == null || clientSecret == null || tenantId == null) {
    print('❌ Missing required environment variables:');
    print('   INTELLITOGGLE_CLIENT_ID');
    print('   INTELLITOGGLE_CLIENT_SECRET');
    print('   INTELLITOGGLE_TENANT_ID');
    exit(1);
  }

  print('🚀 Starting IntelliToggle provider...');
  print('   Environment: $environment');

  await registerIntelliToggleProvider({
    'clientId': clientId,
    'clientSecret': clientSecret,
    'tenantId': tenantId,
    'environment': environment,
  });

  print('✓ IntelliToggle provider initialized successfully!');
}