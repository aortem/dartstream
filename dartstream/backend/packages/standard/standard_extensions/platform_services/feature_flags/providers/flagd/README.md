# DartStream flagd Feature Flag Provider

`ds_flagd_provider` integrates DartStream feature flags with a self-hosted `flagd` instance.

## Features

- Implements `DSFeatureFlagProvider`
- Supports boolean, string, number, and JSON flag evaluation
- Registers with `DSFeatureFlagManager` through `registerFlagdProvider`
- Configurable `flagd` host, port, scheme, and API path

## Installation

```yaml
dependencies:
  ds_flagd_provider: ^0.0.1-pre+1
```

## Quick Start

```dart
import 'package:ds_feature_flags_base/ds_feature_flag_base_export.dart';
import 'package:ds_flagd_provider/ds_flagd_export.dart';

Future<void> main() async {
  await registerFlagdProvider({
    'host': 'localhost',
    'port': 8013,
    'scheme': 'http',
    'apiPath': '/ofrep/v1/evaluate/flags',
  });

  final enabled = await DSFeatureFlagManager.getBooleanFlag(
    'flagd',
    'new-checkout',
    defaultValue: false,
    context: {'targetingKey': 'user-123'},
  );

  print('new-checkout: $enabled');
}
```

## Environment Variables

Set these when running the server entrypoint in `bin/ds_flagd_server.dart`:

- `FLAGD_HOST` (required)
- `FLAGD_PORT` (optional, defaults to `8013`)
- `FLAGD_SCHEME` (optional, defaults to `http`)
- `FLAGD_API_PATH` (optional, defaults to `/ofrep/v1/evaluate/flags`)

## Testing

```bash
dart test
```
