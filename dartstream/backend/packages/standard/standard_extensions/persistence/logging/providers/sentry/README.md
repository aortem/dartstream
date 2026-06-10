# DartStream Sentry Logging Provider

Sentry logging provider for DartStream. This package plugs into `ds_logging_base` and forwards logs to Sentry using the official Dart SDK.

## Install

```yaml
dependencies:
  ds_logging_base: ^0.0.1
  ds_sentry_logging_provider: ^0.0.2
```

## Usage

```dart
import 'package:ds_logging_base/ds_logging_base_export.dart';
import 'package:ds_sentry_logging_provider/ds_sentry_logging_export.dart';

final sentryConfig = {
  'name': 'sentry',
  'dsn': 'https://public-key@o0.ingest.sentry.io/0',
  'environment': 'production',
  'release': '1.2.3',
  'tracesSampleRate': 0.1,
  'sendDefaultPii': false,
  'breadcrumbsEnabled': true,
  'captureInfoAsEvents': false,
  'captureWarningsAsEvents': false,
};

registerSentryLoggingProvider(sentryConfig);

final logger = DSLoggingManager('sentry');
await logger.initialize(sentryConfig);

logger.info('Service started', context: {
  'service': 'api',
  'port': 8080,
});
```

## Configuration

- `dsn` (required)
- `environment` (optional)
- `release` (optional)
- `tracesSampleRate` (optional)
- `sendDefaultPii` (default: false)
- `breadcrumbsEnabled` (default: true)
- `captureInfoAsEvents` (default: false)
- `captureWarningsAsEvents` (default: false)

## Notes

- Info/warn are stored as breadcrumbs by default.
- Errors are sent as events (with exception/stack trace when provided).
