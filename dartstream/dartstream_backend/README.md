# ds_dartstream

A **meta-package** that bundles the entire DartStream framework—tooling, core engine, authentication, persistence, feature-flags, reactive dataflow, and more—so you can get up and running with a single dependency.

---

## 🚀 Quick Start

1. **Add to your project**

   ```bash
   dart pub add ds_dartstream
````

2. **Import the umbrella library**

   ```dart
   import 'package:ds_dartstream/ds_dartstream.dart';
   ```

3. **Initialize the modules you need**

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

## 📦 What’s Included

| Category                 | Packages                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------ |
| **Core Tooling & CLI**   | `ds_tooling` (workspace & bootstrap), `ds_cli`                                       |
| **Standard Engine**      | `ds_standard_engine`                                                                 |
| **Authentication**       | `ds_auth_base`, `ds_auth_auth0`, `ds_auth_cognito`, `ds_auth_firebase`, etc.         |
| **Persistence**          | `ds_db_base`, `ds_db_mysql`, `ds_db_postgres`, `ds_storage_aws`, `ds_storage_gcp`    |
| **Feature Flags**        | `ds_ff_base`, `ds_ff_flagd`, `ds_ff_intellitoggle`                                   |
| **Reactive Dataflow**    | `ds_dataflow_base`, `ds_dataflow_websocket`, `ds_dataflow_broker_base`               |
| **AI Modules (Preview)** | Semantic-release, AI-driven test generation, docs-sync, CLI assistant (coming soon!) |

---

## 🔧 Modules & Patterns

### 1. Core Tooling

* **Workspace orchestration** (path linking, bootstrap)
* **Versioning** & **changelog** helpers
* **Pub-publish** workflows

### 2. Standard Engine

* Common abstractions, utilities, and extensions for pure Dart workloads.

### 3. Authentication

* **Base interfaces** in `ds_auth_base`
* One package per provider (Auth0, Cognito, Firebase, etc.)
* **Manager** for runtime selection and initialization

### 4. Persistence

* **Database**: base interfaces + MySQL/Postgres/Firebase implementations
* **Storage**: base interfaces + AWS S3 / GCP Storage providers
* **Logging**: base interfaces + Console, Stackdriver, etc.

### 5. Feature Flags

* Local and remote flag evaluation
* Integrations with flagd and IntelliToggle

### 6. Reactive Dataflow

* **Events**, **Streams**, **WebSockets**, and **Message Brokers** abstractions
* Plug-and-play provider implementations

---

## 📖 Documentation & Examples

* Full API reference: [dartstream.docs.io](https://dartstream.docs.io)
* GitHub monorepo: [github.com/aortem/dartstream](https://github.com/aortem/dartstream)
* Sample apps: `/examples/` directory in the repo

---

## 🔒 Licensing

* **BSD-3** for all client-side packages
* **ELv2** for service integrations
* **See** [LICENSE](LICENSE.md) for full details.

---

## ❤️ Acknowledgements

Built and maintained by **Aortem Inc.** Want to contribute or report an issue?
👉 [Submit on GitHub](https://github.com/aortem/dartstream/issues)

```
::contentReference[oaicite:0]{index=0}
```
