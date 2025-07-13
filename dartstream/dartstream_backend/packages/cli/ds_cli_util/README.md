# DartStream

## DS CLI Utils Package

A pure-Dart library containing the core logic, commands, and utilities used by the `ds_cli` executable. All workspace‐wide scripts (manifest syncing, registry generation, release tooling, docs sync, QA testing, etc.) live here—decoupled from any specific CLI wrapper.

---

## Key Components

- **`createDartStreamCommandRunner()`**  
  Returns a `CommandRunner` wired with all subcommands.  

- **`SyncManifestCommand`**  
  Reads your workspace manifest (YAML/JSON), validates subpackage paths, and writes an updated manifest.

- **`GenerateRegistryCommand`**  
  Consumes the synced manifest and emits Dart registry files (e.g. `auth_registry.dart`) under specified output paths.

- **`ReleaseCommand`**, **`DocsSyncCommand`**, **`QaTestCommand`**, etc.  
  Other commands for semantic releases, documentation pipelines, and AI‐powered QA testing.

- **Shared Utilities**  
  - Argument and option parsing helpers  
  - File I/O and path resolution  
  - Logging and colored console output  
  - Common data models (manifests, registry entries)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_cli_utils: ^0.1.0
````

If you’re working locally via a workspace:

```yaml
dependencies:
  ds_cli_utils:
    path: ../ds_cli_utils
```

Then run:

```bash
dart pub get
```

---

## Usage

Import and instantiate the command runner in your `bin/` script:

```dart
import 'package:ds_cli_utils/command_runner.dart';

void main(List<String> args) async {
  final runner = createDartStreamCommandRunner();
  await runner.run(args);
}
```

List available commands:

```bash
ds help
```

Run a specific command:

```bash
ds sync-manifest --input=workspace.yaml --output=manifest.yaml
ds generate-registry --manifest=manifest.yaml --output=lib/src/auth_registry.dart
```

Each command supports `--help`:

```bash
ds generate-registry --help
```

---

## Configuration

* **Environment Variables**

  * `DS_CLI_LOG_LEVEL` — `debug`, `info`, `warn`, `error` (default: `info`)
  * `DS_CLI_CONFIG` — path to a custom JSON config file

* **Default Paths**

  * `sync-manifest` looks for `workspace.yaml` or `manifest.yaml` in the repo root
  * `generate-registry` reads the manifest and writes to the specified output path

---

## Examples

```bash
# Sync + generate registry in one pipeline step
ds sync-manifest && ds generate-registry

# Use in GitLab CI
before_script:
  - dart pub global activate ds_cli
script:
  - ds sync-manifest --input=tools/ws.yaml --output=tools/manifest.yaml
  - ds generate-registry --manifest=tools/manifest.yaml --output=lib/src/auth_registry.dart
```

---

## Contributing & Support

1. Fork the repo and create a feature branch.
2. Run `dart analyze` and `dart test`.
3. Submit a merge request with clear commit messages.

---

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


