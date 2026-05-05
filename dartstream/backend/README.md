# DartStream Backend

DartStream backend is the open-source framework layer for Dart-native backend
services, frontend integrations, provider contracts, and extension packages.

## Install

```bash
dart pub add ds_dartstream
```

```dart
import 'package:ds_dartstream/ds_dartstream.dart';
```

## What Is Included

| Category | Packages |
| --- | --- |
| Core tooling and CLI | `ds_cli`, `ds_cli_util` |
| Standard engine | `ds_dartstream_standard_engine`, `ds_dartstream_standard_engine_extension` |
| Authentication | `ds_auth_base`, Auth0, Cognito, EntraID, Firebase, Fingerprint, Magic, Okta, Ping, Stytch, Transmit providers |
| Persistence | `ds_database_base`, `ds_orm_base`, database providers, logging providers, storage providers |
| Feature flags | `ds_feature_flags_base`, `ds_intellitoggle_provider`, `ds_flagd_provider` |
| AI extensions | `ds_ai_base` |
| Reactive dataflow | message broker, WebSocket, events, lifecycle, and notification base packages |

## Framework Boundaries

DartStream open source owns the framework contracts and developer tooling.
DartStream SaaS is a separate managed Aortem product that may use the standard
engine as a base, but SaaS-only control-plane, tenant, billing, credential, and
operations concerns are outside this repository.

## Feature Flags

Feature flagging is provider-neutral through `ds_feature_flags_base`.
IntelliToggle is the official Aortem provider. `flagd` is the only other
approved provider lane in this open-source framework.

## AI Extensions

AI support starts with `ds_ai_base`. DartCodeAI can be implemented as an
official Aortem provider, but the open-source contract stays provider-neutral so
developers can integrate other current AI providers where appropriate.

## ORM Integration

ORM support starts with `ds_orm_base`. DartStream should integrate current,
actively maintained Dart ORM/data-mapping packages through adapters rather than
owning a full ORM implementation. Server-side frameworks that compete with
DartStream should not be documented as preferred ORM integrations.

## Documentation

See:

- `../docs/components/dartstream/modules/ROOT/pages/open-source-boundary.adoc`
- `../docs/components/dartstream/modules/ROOT/pages/package-maturity.adoc`
- `../docs/components/dartstream/modules/ROOT/pages/frontend-support.adoc`
- `../docs/components/dartstream/modules/ROOT/pages/feature-flags.adoc`
- `../docs/components/dartstream/modules/ROOT/pages/ai-extensions.adoc`
- `../docs/components/dartstream/modules/ROOT/pages/orm-integration.adoc`

## Support

Aortem provides open-source support for DartStream. Visit:

https://aortem.io/support
