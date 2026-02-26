# ds_dartstream

A meta-package that bundles the entire DartStream framework - tooling, core engine, authentication, persistence, feature flags, reactive dataflow, and more - so you can get up and running with a single dependency.

---

## Quick Start

1. Add to your project

```bash
dart pub add ds_dartstream
```

2. Import the umbrella library

```dart
import 'package:ds_dartstream/ds_dartstream.dart';
```

3. Initialize the modules you need

```dart
// 1) Initialize core tooling
final tooling = DSTooling();

// 2) Pick and configure an auth provider
DSAuthManager.registerProvider(
  'cognito',
  DSCognitoAuthProvider(),
  DSAuthProviderMetadata(...),
);
final auth = DSAuthManager('cognito');
await auth.initialize({ /* config */ });

// 3) Use storage or logging
DSStorageManager.registerProvider(
  'gcs',
  DSGcsStorageProvider(),
  DSStorageProviderMetadata(type: 'gcs', region: 'us-central1'),
);
final storage = DSStorageManager('gcs');
await storage.uploadFile('path/to/object', dataBytes);
```

---

## What's Included

| Category               | Packages |
| ---------------------- | -------- |
| Core Tooling & CLI     | `ds_tooling` (workspace & bootstrap), `ds_cli` |
| Standard Engine        | `ds_dartstream_standard_engine` |
| Authentication         | `ds_auth_base`, `ds_auth0_auth_provider`, `ds_cognito_auth_provider`, `ds_firebase_auth_provider`, `ds_magic_auth_provider`, `ds_okta_auth_provider`, `ds_stytch_auth_provider`, `ds_transmit_auth_provider`, `ds_fingerprint_auth_provider`, `ds_entraid_auth_provider`, `ping_identity_dart_auth_sdk` |
| Persistence            | `ds_database_base`, `ds_postgres_database`, `ds_mongo_database`, `ds_firebase_database`, `ds_logging_base`, `ds_otlp_logging_provider`, `ds_sentry_logging_provider`, `ds_aws_storage_provider`, `ds_gcp_storage_provider` |
| Feature Flags          | `ds_feature_flags_base`, `ds_flagd_provider`, `ds_intellitoggle_provider` |
| Reactive Dataflow      | `ds_message_broker_base`, `ds_gcp_pubsub_message_broker_provider`, `ds_websocket_base`, `ds_socket_io_websocket_provider` |
| AI Modules (Preview)   | Semantic-release, AI-driven test generation, docs-sync, CLI assistant (coming soon!) |

---

## Modules and Patterns

### 1. Core Tooling

- Workspace orchestration (path linking, bootstrap)
- Versioning and changelog helpers
- Pub publish workflows

### 2. Standard Engine

- Common abstractions, utilities, and extensions for pure Dart workloads.

### 3. Authentication

- Base interfaces in `ds_auth_base`
- One package per provider (Auth0, Cognito, Firebase, etc.)
- Manager for runtime selection and initialization

### 4. Persistence

- Database: base interfaces plus Postgres, Mongo, and Firestore implementations
- Storage: base interfaces plus AWS S3 and GCP Storage providers
- Logging: base interfaces plus OTLP and Sentry providers

### 5. Feature Flags

- Local and remote flag evaluation
- Integrations with flagd and IntelliToggle

### 6. Reactive Dataflow

- Events, Streams, WebSockets, and Message Brokers abstractions
- Plug-and-play provider implementations

---

## Documentation and Examples

- Full API reference: https://dartstream.docs.io
- GitHub monorepo: https://github.com/aortem/dartstream
- Sample apps: /examples/ directory in the repo

---

## Licensing

- BSD-3 for all client-side packages
- ELv2 for service integrations
- See LICENSE for full details.

---

## Acknowledgements

Built and maintained by Aortem Inc. Want to contribute or report an issue?
Submit on GitHub: https://github.com/aortem/dartstream/issues
