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

## CLI

Install the public `dartstream` executable from pub.dev:

```bash
dart pub global activate ds_dartstream
```

Verify the hosted runner after activation:

```bash
dartstream --help
dartstream init --help
dartstream configure --help
dartstream validate --help
dartstream login --token <token>
```

On Windows, Dart writes global executables to
`%LOCALAPPDATA%\Pub\Cache\bin`. Add that directory to `PATH` if `dartstream`
is not recognized after activation.

## What Is Included

## Local model generation

The source CLI supports the documented local identity model:

```bash
dartstream generate --type model --name User
```

This creates `lib/src/models/user.dart` with id, name, createdAt and optional
updatedAt, JSON conversion, copyWith and equality by id. PascalCase and
snake_case names are supported. Existing files and linked output paths are
refused; `--output` may select a directory inside the project. This generates
local Dart code and does not create a database, API or cloud resource.
The hosted 0.0.11 package does not yet include this source feature. Extension
and CRUD scaffold generation are described below for the source CLI.

## Local provider adapter generation

```bash
dartstream generate --type provider --name Payment
```

This source command creates `lib/src/providers/ds_payment_provider.dart` with a
`DSPaymentProvider` callback adapter. Supply `onInitialize`, `onDispose` and
`onAction`; calls await those handlers and propagate their actual failures.
The application owns lifecycle ordering, authentication, authorization and
vendor behavior. The adapter embeds no credentials, registers no engine service
and creates no cloud resources. It does not claim a configured payment service.
PascalCase/snake_case names and a relative in-project `--output` are supported;
existing files and linked paths are refused. Hosted 0.0.11 is unchanged; this
feature requires a future normal reviewed package release.

## Local API routing generation

Add direct `shelf` and `shelf_router` dependencies to the customer project, then:

```bash
dart pub add shelf shelf_router
dartstream generate --type api --name Product
```

This source command creates `lib/src/api/product_api.dart` with a `ProductApi`
routing adapter for GET/POST `/` and GET/PUT/DELETE `/<id>`. Its constructor
requires all five application handlers; the generated code returns their actual
responses and never fabricates a successful CRUD result. Mount it behind your
application's authentication/authorization middleware. Handlers must implement
validation, storage and business behavior. This command creates no database or
cloud resources, installs no dependencies and preserves customer files.
PascalCase/snake_case names and a relative in-project `--output` are supported;
existing files and linked paths are refused. Hosted 0.0.11 is unchanged; this
feature needs a future normal reviewed package release.

## Local extension generation

The source CLI's `generate --type extension --name Payment` creates a complete
local package in `packages/ds_payment_extension`, including a discoverable
manifest and an implementation of the maintained `LifecycleHook` contract.
Provide the required synchronous lifecycle callbacks and an execution callback;
execution awaits the application's work and propagates its failures. Resolve
the package dependencies with `dart pub get` in its directory. The package is
private (`publish_to: none`) and generation does not register or execute it.
`discover` lists its metadata; `discover --register` preserves existing disabled
states and customer metadata. Register runtime enhancements explicitly in the
application after authorization. `--output` selects a relative in-project parent
directory (use a directory under `packages` for discovery). Existing package
directories and linked output paths are refused. Hosted 0.0.11 needs a future
reviewed release to include this work.

## Local CRUD scaffold generation

```bash
dartstream generate --type scaffold --name Product
```

The source CLI creates a private package at `packages/ds_product_scaffold` with
the same identity model and five-handler Shelf routing adapter as the model/API
generators. Run `dart pub get` in the package and add it as an explicit path
dependency to the application. Import its library and supply every list,
create, get, update and delete handler. Mount it behind application auth;
handlers implement actual validation, persistence and responses. Generation
does not register routes, configure storage, start a server or deploy resources.
Existing package directories and linked paths are refused; `--output` selects
an in-project parent directory. Customer manifests remain unchanged. Hosted
0.0.11 is unchanged; a future reviewed package release is required.

## Local validation CI setup

OpenAPI client names use lowercase letters and digits with single underscores
between nonempty words (for example, `demo_api_2`). Trailing or repeated
underscores are rejected with a usage error before any output is created.
This source correction requires a reviewed package release; hosted 0.0.11 is
unchanged.

The source CLI's `init` checks every starter file and parent directory before
writing. Links, Windows junctions and conflicting directories are refused,
including with `--force`. Existing regular starter files are preserved unless
`--force` explicitly requests replacement. Project display names remain a
single YAML value. This correction requires a future reviewed package release;
hosted 0.0.11 remains unchanged.

In the source CLI, `dartstream setup` creates `.gitlab-ci.yml` when
`dartstream.yaml` selects `cicd.provider: gitlab`. With `cicd.provider: github`,
it creates `.github/workflows/dartstream-validation.yml` instead, using the same
immutable SDK image, SHA-pinned checkout, read-only repository permissions and
no persisted checkout credentials. Existing workflows and linked paths are
preserved or refused. First add the `test` package
and at least one `test/*_test.dart` test to your project. The generated pipeline
uses a pinned Dart SDK image and runs dependency resolution, analysis and tests.
Existing CI files, configuration and package manifests are preserved. Review
the file through your normal repository process before pushing it.

`dartstream setup --middleware` separately creates
`lib/src/middleware/dartstream_middleware.dart`. Add a direct `shelf` dependency
first. Import the generated file and call
`withDartStreamMiddleware(handler: routes, middleware: [authenticate, authorize])`
with your application's actual handlers. The first layer is outermost: requests
enter in list order and responses return in reverse order. The adapter preserves
Shelf context, bodies, short-circuit responses and error propagation. Supply
your own authentication, authorization and error handling; no policy is enabled
by generation. Existing middleware files, CI, manifests and configuration are
preserved. Use plain `setup` separately when validation CI is needed.

`cicd.provider: none` creates no file. Other CI providers, SaaS and
advanced feature/tool setup remain coming soon. This command creates no cloud resources
and configures no deployment. These source changes require a future package
release before they are available through hosted activation.

## Framework packages

The source CLI's `dartstream extensions` lists enabled registry entries by default.
Use `--inactive` to include disabled entries and `--level core|extended|third-party|all`
to filter the scope. Text and `--json` output use the same filters. Historical
`thirdParty` levels and legacy entries with no level belong to `third-party`.
Listing never writes the registry or changes enable/disable choices. This source
behavior is not yet part of the hosted 0.0.11 release.

`enable-extension` and `disable-extension` change only the named entry's enabled
state, preserving customer registry metadata and other entries. Repeating the
same state leaves the file bytes unchanged. Listing, toggling and discovery use
the same validation: malformed registries, duplicate names and linked registry
paths are refused, and concurrent edits are preserved. These corrections also
require a future reviewed package release.

Disabling an enabled extension is refused when other enabled entries declare
it as a dependency. Exact names and name-plus-version-constraint declarations
are recognized. Disable the dependents first, or explicitly pass `--force` to
disable only the target while leaving dependent entries unchanged. Invalid
dependency metadata is refused even with `--force`; no registry bytes change
on a refused command. This source safeguard is not in hosted 0.0.11 yet.

The source CLI's `dartstream discover` inspects local `packages/**/manifest.yaml`
files without loading extension code or changing state. Use `--register` to
merge validated metadata into the registry while preserving disabled entries
and customer metadata. Maintained `thirdParty` manifests are normalized to
`third-party`. Linked package, manifest and registry directories are refused.
These source corrections require a future reviewed package release; hosted
0.0.11 remains unchanged.

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

## Required OpenAPI inputs

Source-generated OpenAPI clients check inline required query parameters and
required request bodies before sending a request. Supply query values through
the operation's `query` map and JSON bodies through `body`; an empty query value
counts as present. Operation-level parameters override matching path-level
parameters by name and location. Inline parameter and request-body references
before generating; malformed required flags and duplicate parameter identities
are rejected before writing. Schema/type/default and header/cookie validation
remain application-owned. Existing generated packages are preserved. Hosted
0.0.11 is unchanged; this requires a future reviewed package release.
