# DartStream Events (ds_events_base)

Base event interfaces and provider registration for DartStream.

## OSS Provider Policy

The open-source framework only ships adapters for the most battle-tested and widely adopted eventing backends. Vendor-specific adapters that are not strongly maintained in Dart are reserved for the SaaS edition unless community demand justifies OSS support.

## Supported OSS Providers (Lean List)

None yet. Eventing providers are currently SaaS-only or community-driven.

## Vendor Profiles (Docs-Only)

These are recommended stacks for teams that prefer a cloud-vendor mental model. They are **not** provider packages and do **not** appear in the registry.

- **GCP profile**
  - Eventarc (SaaS)

## Provider Contract

Providers implement the shared interface from `ds_events_base` and are registered with `DSEventManager`.

---

If you plan to publish a provider, ensure it includes:
- `pubspec.yaml` with `sdk: ^3.12.2`
- `LICENSE` (DartStream standard)
- `CHANGELOG.md`
- `manifest.yaml` for registry/discovery
