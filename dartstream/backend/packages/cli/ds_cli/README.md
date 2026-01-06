````markdown
# ds_cli

**DartStream CLI** (`ds`)  
A thin wrapper around the `ds_cli_utils` library that provides a single global executable for managing your DartStream workspace and automating common tasks.

---

## Key Components

- **`bin/ds_cli.dart`**  
  The entrypoint for the `ds` executable.  
- **`sync_manifest.dart`**  
  Synchronizes your workspace manifest (e.g. pulls in every sub-package).  
- **`generate_registry.dart`**  
  Generates a Dart registry file (e.g. auth provider registrations) from your manifest.  
- **Other commands** (release management, docs sync, QA testing) live under the `ds` CLI surface.

---

## Installation

Activate globally with pub:

```bash
dart pub global activate ds_cli
````

Make sure your **PATH** includes:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

---

## Usage

List all available commands:

```bash
ds help
```

Typical workflow:

```bash
# 1. Sync your manifest
ds sync-manifest --input=workspace.yaml

# 2. Generate provider registry
ds generate-registry --output=lib/src/auth_registry.dart

# 3. (Optional) Run other ds commands:
ds release        # semantic release
ds docs-sync      # documentation pipeline
ds qa-test        # run AI-powered tests
```

Each command supports `--help`:

```bash
ds generate-registry --help
```

---

## Configuration

By default, commands will look for a `workspace.yaml` or `manifest.yaml` in the repo root. You can override:

```bash
ds sync-manifest --input=tools/manifest.yml
```

Environment variables:

* `DS_CLI_LOG_LEVEL` – `debug`, `info`, `warn`, `error` (default: `info`)
* `DS_CLI_CONFIG` – path to a custom JSON config

---

## Examples

```bash
# Sync and generate all auth providers in one go
ds sync-manifest && ds generate-registry
```

Add these two lines to your CI script before building:

```yaml
- dart pub global activate ds_cli
- ds sync-manifest && ds generate-registry
```

---

## Contributing & Support

1. Fork the repo and create a feature branch.
2. Run `dart test` and `dart analyze`.
3. Submit a PR with clear commit messages.

---

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


```