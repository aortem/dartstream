# DartStream Logging (ds_logging_base)

Base logging interfaces and provider registration for DartStream. This is the OSS telemetry logging layer aligned with the `ds_telemetry` spec in `DartStream/AGENTS.md`.

## Scope (OSS Only)

- Open-source providers only. No DartStream Cloud/SaaS provider lives in this repo.
- Logging only (no metrics or tracing SDK layers yet).
- Vendor-neutral by default via OTLP.

## Design Goals (AGENTS.md)

- OTLP-first telemetry with a plug-and-play Sentry option.
- Vendor-neutral defaults with a stable public API.
- OSS-only boundary (no SaaS integrations in this repo).
- Naming note: the `ds_telemetry` spec is currently implemented as `ds_logging_base` plus provider packages.

## Non-goals

- Full OpenTelemetry SDK implementation.
- Cloud-vendor specific logging adapters (CloudWatch, GCP Logging, etc.).

---

## Supported Logging Providers

DartStream ships logging providers that integrate with common observability stacks. Choose the vendor that fits your team and wire it through the shared `DSLoggingManager` API.

| Provider | DartStream Package | Upstream SDK / Docs | Source |
| --- | --- | --- | --- |
| **OpenTelemetry (OTLP)** | `ds_otlp_logging_provider` | OTLP/HTTP JSON logs (`/v1/logs`) and Collector docs: https://opentelemetry.io/docs/collector/ | https://github.com/aortem/DartStream/tree/development/DartStream/backend/packages/standard/standard_extensions/persistence/logging/providers/otlp |
| **Sentry** | `ds_sentry_logging_provider` | `sentry` Dart SDK: https://pub.dev/packages/sentry | https://github.com/aortem/DartStream/tree/development/DartStream/backend/packages/standard/standard_extensions/persistence/logging/providers/sentry |

---

## Provider Contract

All providers implement the same interface:

- `initialize(config)`
- `info`, `warn`, `error`
- `flush()`
- `dispose()`

Logging calls are best-effort. Transport errors are swallowed by the providers so logging does not crash your app. Invalid configuration errors are surfaced during `initialize`.

Registration only makes a provider available. You must call `initialize()` on the manager before logs are emitted.

Note: this is the current API surface. The `ds_telemetry` spec calls for richer structured events and additional log levels in a future iteration.

---

## Package Conflicts and Aliases

In some cases, core Dart packages have naming conflicts (ie. same method, classname). For some packages, we build wrappers and use the DS prefix to avoid those conflicts.

In other cases, we may avoid using a package altogether. We will keep the documentation up to date as often as possible.

## Licensing

All DartStream packages are licensed under BSD-3, except for the services packages, which uses the ELv2 license, and the DartStream SDK packages, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers). See the LICENSE file for more details.

## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!

---

## Quick Start Guide

### Prerequisites

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  # Base logging package
  ds_logging_base: ^0.0.2
  # Choose one or both providers
  ds_sentry_logging_provider: ^0.0.1
  ds_otlp_logging_provider: ^0.0.1
```

### Basic Setup

```dart
import 'package:ds_logging_base/ds_logging_base_export.dart';
import 'package:ds_sentry_logging_provider/ds_sentry_logging_export.dart';
import 'package:ds_otlp_logging_provider/ds_otlp_logging_export.dart';

// Register providers (choose one or both)
final sentryConfig = {
  'name': 'sentry',
  'dsn': 'https://public-key@o0.ingest.sentry.io/0',
  'environment': 'production',
};
registerSentryLoggingProvider(sentryConfig);

final otlpConfig = {
  'name': 'otlp',
  'endpoint': 'http://otel-collector:4318/v1/logs',
  'serviceName': 'DartStream-api',
  'environment': 'production',
};
registerOtlpLoggingProvider(otlpConfig);

// Create a logger instance (choose one provider per manager instance)
final logger = DSLoggingManager('sentry'); // or 'otlp'
await logger.initialize(sentryConfig); // or otlpConfig

logger.info('Server started', context: {
  'service': 'api',
  'port': 8080,
});
```

---

## Sentry Logging

Sentry is a fast, plug-and-play option for errors, breadcrumbs, and lightweight log capture. It is ideal for startups and teams that want a quick setup without running any infrastructure.

### Sentry Setup

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
```

### Sentry Usage Examples

```dart
try {
  // ... work
} catch (e, st) {
  logger.error(
    'Order checkout failed',
    error: e,
    stackTrace: st,
    context: {
      'orderId': 'ord_123',
      'userId': 'user_456',
    },
  );
}

logger.warn('Inventory running low', context: {
  'sku': 'ABC-123',
  'remaining': 3,
});
```

### Sentry Configuration Reference

- `dsn` (required)
- `environment` (optional)
- `release` (optional)
- `tracesSampleRate` (optional)
- `sendDefaultPii` (default: false)
- `breadcrumbsEnabled` (default: true)
- `captureInfoAsEvents` (default: false)
- `captureWarningsAsEvents` (default: false)

---

## OpenTelemetry (OTLP) Logging

OpenTelemetry is the vendor-neutral standard for logs, traces, and metrics. Use the OTLP provider to send structured logs to any collector or observability backend.

### OTLP Setup

```dart
import 'package:ds_logging_base/ds_logging_base_export.dart';
import 'package:ds_otlp_logging_provider/ds_otlp_logging_export.dart';

final otlpConfig = {
  'name': 'otlp',
  'endpoint': 'http://otel-collector:4318/v1/logs',
  'serviceName': 'DartStream-api',
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
```

### OTLP Usage Examples

```dart
logger.info('Request received', context: {
  'http.method': 'GET',
  'http.path': '/v1/orders',
  'requestId': 'req_123',
});

logger.error('Database query failed', context: {
  'db.system': 'postgres',
  'db.statement': 'SELECT * FROM orders WHERE id = $1',
});
```

### OTLP Configuration Reference

- `endpoint` (required)
- `headers` (optional)
- `serviceName` (optional)
- `serviceVersion` (optional)
- `environment` (optional)
- `resourceAttributes` (optional)
- `timeout` (optional, seconds)

---

## Context and Attributes

All log calls accept a `context` map. The providers attach this data as attributes (OTLP) or contexts (Sentry). Avoid sensitive values unless you explicitly intend to store them in your logging backend.

```dart
logger.info('User login', context: {
  'userId': 'user_123',
  'tenantId': 'tenant_abc',
  'requestId': 'req_456',
});
```

### Recommended Context Keys

- `traceId`, `spanId`
- `requestId`
- `tenantId`, `userId`, `sessionId`
- `serviceName`, `serviceVersion`, `environment`, `release`

---

## Roadmap (Spec Items Not Yet Implemented)

These items are part of the `ds_telemetry` spec but are not in the current implementation yet.

### Redaction (planned)

Before export, redact:

- password, token, secret, authorization, cookie
- JWTs and long base64 strings
- large payload truncation

### Sampling (planned)

Default sampling targets:

| Level       | Sampling |
| ----------- | -------- |
| fatal/error | 100%     |
| warn        | 100%     |
| info        | 25%      |
| debug       | 5%       |
| trace       | 1%       |

### Other planned work

- Structured `DsEvent` / `DsContext` models with additional log levels (`trace`, `debug`, `fatal`).
- Backpressure-safe queues and fallback sinks.
- Metrics and tracing providers.

---

## Troubleshooting

### Common Issues

1. **Sentry DSN missing**
   ```dart
   // This will throw during initialization
   registerSentryLoggingProvider({});
   final logger = DSLoggingManager('sentry');
   await logger.initialize({'dsn': ''});
   ```

2. **OTLP endpoint missing**
   ```dart
   // This will throw during initialization
   registerOtlpLoggingProvider({});
   final logger = DSLoggingManager('otlp');
   await logger.initialize({});
   ```

3. **No logs appearing**
   - Confirm the provider name passed to `DSLoggingManager` matches the registration name.
   - Ensure `initialize()` has been called with a valid config.
   - Ensure network access to the OTLP collector or Sentry ingest endpoint.

### Debug Mode

```dart
DSLoggingManager.enableDebugging = true;
```

---

## Choosing the Right Provider

- **OpenTelemetry (OTLP)** is best when you already have an observability pipeline or need vendor neutrality.
- **Sentry** is best for quick setup, error tracking, and lightweight breadcrumbs without managing infrastructure.

---
