# Local extension discovery (unreleased)

This change is prepared for a future CLI release. Published 0.0.11 is unchanged.

`dartstream discover` reads `packages/**/manifest.yaml` in the current project.
Use `--project <directory>` to select another project and `--no-register` to
inspect manifests without changing files. It never loads extension code or
generates engine registration code.

A manifest uses the existing discovery provider's fields:

```yaml
name: CustomerAuth
version: 1.0.0
entry_point: lib/customer_auth.dart
level: core
dependencies: []
```

The name, version and entry point are required. The entry point must exist
inside the extension directory. Supported levels are `core`, `extended` and
`third-party` (default). Dependencies are recorded as names; runtime dependency
resolution and engine activation remain separate work. All manifests must be
valid and have unique names before the registry changes. `--no-validate` is
rejected, including when registration is disabled.

Registration merges validated metadata into `.dartstream/extensions.json`.
Existing enabled/disabled choices, unknown fields and entries not found in this
scan remain intact. New entries are enabled in the local registry only. Invalid
registry content is preserved with an error. Repeated discovery with unchanged
metadata leaves the file bytes intact. Symbolic link directories are not followed.

Setup and generation remain guarded. Full Phase 2, live engine registration and
published-package acceptance are incomplete.
