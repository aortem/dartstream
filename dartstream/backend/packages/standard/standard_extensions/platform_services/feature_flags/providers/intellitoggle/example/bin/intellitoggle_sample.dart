import 'dart:io';
import 'package:ds_intellitoggle_provider/ds_intellitoggle_export.dart';

/// Sample application demonstrating IntelliToggle integration with DartStream.
///
/// This example shows how to:
/// - Initialize the IntelliToggle provider using OAuth2 credentials
/// - Evaluate boolean, string, number, and JSON feature flags
/// - Use targeting context for user-specific flag evaluation
/// - Handle errors gracefully
///
/// Required environment variables:
/// ```bash
/// INTELLITOGGLE_CLIENT_ID=your-client-id
/// INTELLITOGGLE_CLIENT_SECRET=your-client-secret
/// INTELLITOGGLE_TENANT_ID=your-tenant-id
/// ```
Future<void> main() async {
  print('DartStream IntelliToggle Feature Flags Example\n');

  // Load credentials from environment variables
  // NEVER hardcode credentials in source code
  final clientId = Platform.environment['INTELLITOGGLE_CLIENT_ID'];
  final clientSecret = Platform.environment['INTELLITOGGLE_CLIENT_SECRET'];
  final tenantId = Platform.environment['INTELLITOGGLE_TENANT_ID'];

  if (clientId == null || clientSecret == null || tenantId == null) {
    print('Missing required environment variables:');
    print('   INTELLITOGGLE_CLIENT_ID');
    print('   INTELLITOGGLE_CLIENT_SECRET');
    print('   INTELLITOGGLE_TENANT_ID');
    exit(1);
  }

  // Step 1: Create provider instance and initialize it
  final provider = DSIntelliToggleProvider(
    clientId: clientId,
    clientSecret: clientSecret,
    tenantId: tenantId,
  );

  print('Initializing IntelliToggle provider...');
  await provider.initialize();
  print('Provider initialized successfully!\n');

  // Step 2: Evaluate a boolean flag
  print('--- Boolean Flag Evaluation ---');
  final isNewDashboardEnabled = await provider.getBooleanFlag(
    'new-dashboard',
    defaultValue: false,
    context: {
      'targetingKey': 'user-123',
      'role': 'admin',
      'plan': 'enterprise',
    },
  );
  print('new-dashboard: $isNewDashboardEnabled\n');

  // Step 3: Evaluate a string flag
  print('--- String Flag Evaluation ---');
  final themeColor = await provider.getStringFlag(
    'theme-color',
    defaultValue: 'blue',
    context: {
      'targetingKey': 'user-123',
      'plan': 'premium',
    },
  );
  print('theme-color: $themeColor\n');

  // Step 4: Evaluate a number flag
  print('--- Number Flag Evaluation ---');
  final maxRetries = await provider.getNumberFlag(
    'max-retries',
    defaultValue: 3,
    context: {
      'targetingKey': 'service-api',
      'environment': 'production',
    },
  );
  print('max-retries: $maxRetries\n');

  // Step 5: Evaluate a JSON flag
  print('--- JSON Flag Evaluation ---');
  final featureConfig = await provider.getJsonFlag(
    'feature-config',
    defaultValue: {'enabled': false, 'limit': 100},
    context: {
      'targetingKey': 'org-456',
      'tier': 'premium',
    },
  );
  print('feature-config: $featureConfig\n');

  // Step 6: Get detailed evaluation result
  print('--- Detailed Flag Evaluation ---');
  final result = await provider.evaluateFlag(
    'new-checkout-flow',
    context: {
      'targetingKey': 'user-123',
      'region': 'us-east',
    },
  );
  print('Flag value: ${result.value}');
  print('Reason: ${result.reason}');
  print('Variant: ${result.variant}\n');

  // Step 7: Shutdown provider
  await provider.shutdown();
  print('Example completed successfully!');
}
