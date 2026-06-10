# DartStream Notifications (ds_notifications_base)

Base notification interfaces and provider registration for DartStream.

## OSS Provider Policy

The open-source framework only ships adapters for the most battle-tested and widely adopted notification backends. Vendor-specific adapters that are not strongly maintained in Dart are reserved for the SaaS edition unless community demand justifies OSS support.

## Supported OSS Providers (Lean List)

None yet. Notification providers are currently SaaS-only or community-driven.

## Provider Contract

Providers implement the shared interface from `ds_notifications_base` and are registered with `DSNotificationManager`.

---

If you plan to publish a provider, ensure it includes:
- `pubspec.yaml` with `sdk: ^3.12.2`
- `LICENSE` (DartStream standard)
- `CHANGELOG.md`
- `manifest.yaml` for registry/discovery
