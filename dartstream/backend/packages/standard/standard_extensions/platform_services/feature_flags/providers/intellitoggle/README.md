# DartStream IntelliToggle Feature Flag Provider

A DartStream provider for [IntelliToggle](https://www.intellitoggle.com), a Dart-native feature flag service. This package integrates IntelliToggle's OpenFeature-compliant SDK into the DartStream framework, allowing you to manage feature flags with minimal setup.

## Features

- **Complete DSFeatureFlagProvider Implementation** - Full feature parity with other DartStream feature flag providers
- **OpenFeature Compliant** - Built on the OpenFeature standard via `openfeature_provider_intellitoggle`
- **OAuth2 Authentication** - Secure machine-to-machine authentication
- **Flag Evaluation** - Boolean, string, number, and JSON flag support
- **Targeting & Context** - User-specific flag evaluation with targeting rules
- **Environment Presets** - Production and development configurations out of the box
- **Event Handling** - Provider lifecycle event subscriptions
- **Error Handling** - Comprehensive error mapping for IntelliToggle API errors

## Installation

Add the IntelliToggle provider to your `pubspec.yaml`:
```yaml
dependencies:
  ds_feature_flags_base: ^0.0.1-pre+1
  ds_intellitoggle_provider: ^0.0.1-pre+1
```

## Prerequisites

1. **Create an IntelliToggle account** at [app.intellitoggle.com](https://app.intellitoggle.com/auth/register)
2. **Create a project** in the IntelliToggle dashboard
3. **Create OAuth2 Client Credentials** under Settings → Create OAuth2 Client
4. **Save your credentials** in a `.env` file - never commit them to version control

## Environment Setup
```bash
# Linux/macOS
export INTELLITOGGLE_CLIENT_ID="your-client-id"
export INTELLITOGGLE_CLIENT_SECRET="your-client-secret"
export INTELLITOGGLE_TENANT_ID="your-tenant-id"
export INTELLITOGGLE_ENVIRONMENT="production"

# Windows
set INTELLITOGGLE_CLIENT_ID="your-client-id"
set INTELLITOGGLE_CLIENT_SECRET="your-client-secret"
set INTELLITOGGLE_TENANT_ID="your-tenant-id"
set INTELLITOGGLE_ENVIRONMENT="production"
```

## Quick Start

### Entry-point registration (recommended)
```dart
import 'dart:io';
import 'package:ds_intellitoggle_provider/ds_intellitoggle_export.dart';

Future<void> main() async {
  await registerIntelliToggleProvider({
    'clientId': Platform.environment['INTELLITOGGLE_CLIENT_ID']!,
    'clientSecret': Platform.environment['INTELLITOGGLE_CLIENT_SECRET']!,
    'tenantId': Platform.environment['INTELLITOGGLE_TENANT_ID']!,
    'environment': 'production',
  });
}
```

### Basic Flag Evaluation
```dart
import 'dart:io';
import 'package:ds_intellitoggle_provider/ds_intellitoggle_export.dart';

Future<void> main() async {
  final provider = DSIntelliToggleProvider(
    clientId: Platform.environment['INTELLITOGGLE_CLIENT_ID']!,
    clientSecret: Platform.environment['INTELLITOGGLE_CLIENT_SECRET']!,
    tenantId: Platform.environment['INTELLITOGGLE_TENANT_ID']!,
  );

  await provider.initialize();

  // Evaluate a boolean flag
  final isEnabled = await provider.getBooleanFlag(
    'new-dashboard',
    defaultValue: false,
    context: {
      'targetingKey': 'user-123',
      'role': 'admin',
      'plan': 'enterprise',
    },
  );

  print('new-dashboard: $isEnabled');

  await provider.shutdown();
}
```

## Configuration

### Production (default)
```dart
final provider = DSIntelliToggleProvider(
  clientId: clientId,
  clientSecret: clientSecret,
  tenantId: tenantId,
  config: DSIntelliToggleConfig.production(),
);
```

### Development
```dart
final provider = DSIntelliToggleProvider(
  clientId: clientId,
  clientSecret: clientSecret,
  tenantId: tenantId,
  config: DSIntelliToggleConfig.development(),
);
```

### Custom Configuration
```dart
final provider = DSIntelliToggleProvider(
  clientId: clientId,
  clientSecret: clientSecret,
  tenantId: tenantId,
  config: DSIntelliToggleConfig(
    timeout: Duration(seconds: 15),
    enablePolling: true,
    pollingInterval: Duration(minutes: 2),
    enableStreaming: true,
    maxRetries: 5,
    enableLogging: true,
  ),
);
```

## API Reference

### DSIntelliToggleProvider

#### Constructor
```dart
DSIntelliToggleProvider({
  required String clientId,
  required String clientSecret,
  required String tenantId,
  DSIntelliToggleConfig? config,
})
```

#### Methods
```dart
// Initialize the provider (must be called first)
Future<void> initialize();

// Shutdown and cleanup
Future<void> shutdown();

// Flag evaluation
Future<bool> getBooleanFlag(String flagKey, {bool defaultValue, Map<String, dynamic>? context});
Future<String> getStringFlag(String flagKey, {String defaultValue, Map<String, dynamic>? context});
Future<num> getNumberFlag(String flagKey, {num defaultValue, Map<String, dynamic>? context});
Future<Map<String, dynamic>> getJsonFlag(String flagKey, {Map<String, dynamic> defaultValue, Map<String, dynamic>? context});
Future<DSFeatureFlagEvaluationResult> evaluateFlag(String flagKey, {Map<String, dynamic>? context});
```

### DSIntelliToggleConfig Options

| Option | Description | Default |
|--------|-------------|---------|
| `baseUri` | API endpoint | `https://api.intellitoggle.com` |
| `timeout` | Request timeout | `10 seconds` |
| `enablePolling` | Poll for updates | `true` |
| `pollingInterval` | Polling frequency | `5 minutes` |
| `enableStreaming` | Real-time updates | `false` |
| `maxRetries` | Retry attempts | `3` |
| `enableLogging` | Debug logging | `false` |

## Error Handling
```dart
try {
  final result = await provider.getBooleanFlag('my-flag');
} on DSIntelliToggleException catch (e) {
  switch (e.code) {
    case 'unauthorized':
      print('Invalid OAuth2 credentials');
      break;
    case 'flag_not_found':
      print('Flag does not exist');
      break;
    case 'rate_limit_exceeded':
      print('Too many requests');
      break;
    case 'timeout':
      print('Request timed out');
      break;
    default:
      print('Error: ${e.message}');
  }
}
```

## Testing
```bash
# Run all tests
dart test

# Run with coverage
dart test --coverage

# Run integration test (requires INTELLITOGGLE_* env vars)
dart test test/ds_intellitoggle_integration_test.dart
```

## Publish Validation

```bash
dart pub publish --dry-run
```

## Security Best Practices

- **Never hardcode credentials** in source code
- **Use environment variables** for all sensitive values
- **Rotate OAuth2 credentials** regularly
- **Use least privilege scopes** when creating OAuth2 clients
- **Never commit `.env` files** to version control

## IntelliToggle Resources

- [IntelliToggle Documentation](https://intellitoggle-docs.web.app)
- [IntelliToggle Dashboard](https://app.intellitoggle.com)
- [OpenFeature Standard](https://openfeature.dev)

## License

This package is part of the DartStream project and is licensed under the BSD-3 License.

## Support

For issues with the DartStream integration, visit the [DartStream repository](https://github.com/aortem/dartstream-opensource).

For issues with IntelliToggle itself, visit the [IntelliToggle project](https://gitlab.com/dartapps/apps/intellitoggle/intellitoggle).
