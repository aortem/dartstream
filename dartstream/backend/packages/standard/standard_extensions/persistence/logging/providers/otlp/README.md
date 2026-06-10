# DartStream OTLP Logging Provider

OpenTelemetry (OTLP) logging provider for DartStream. This package plugs into `ds_logging_base` and exports logs to any OTLP-compatible backend.

## Install

```yaml
dependencies:
  ds_logging_base: ^0.0.1
  ds_otlp_logging_provider: ^0.0.2
```

## Usage

```dart
import 'package:ds_logging_base/ds_logging_base_export.dart';
import 'package:ds_otlp_logging_provider/ds_otlp_logging_export.dart';

final otlpConfig = {
  'name': 'otlp',
  'endpoint': 'http://otel-collector:4318/v1/logs',
  'serviceName': 'dartstream-api',
  'serviceVersion': '1.2.3',
  'environment': 'production',
  'headers': {
    'x-api-key': 'your-api-key',
  },
  'resourceAttributes': {
    'deployment.region': 'us-central1',
  },
  'timeout': 2,
};

registerOtlpLoggingProvider(otlpConfig);

final logger = DSLoggingManager('otlp');
await logger.initialize(otlpConfig);

logger.info('Request received', context: {
  'http.method': 'GET',
  'http.path': '/v1/orders',
  'requestId': 'req_123',
});
```

## Configuration

- `endpoint` (required) - OTLP/HTTP logs endpoint (usually `/v1/logs`)
- `headers` (optional)
- `serviceName` (optional)
- `serviceVersion` (optional)
- `environment` (optional)
- `resourceAttributes` (optional)
- `timeout` (optional, seconds)

## Notes

- Uses OTLP/HTTP JSON payloads for logs.
- Transport errors are swallowed so logging never crashes the app.
