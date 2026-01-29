# DartStream WebSockets (ds_websocket_base)

Base WebSocket interfaces and provider registration for DartStream.

## OSS Provider Policy

The open-source framework only ships adapters for the most battle-tested and widely adopted WebSocket stacks. Vendor-specific adapters that are not strongly maintained in Dart are reserved for the SaaS edition unless community demand justifies OSS support.

## Supported OSS Providers (Lean List)

| Provider | Pub.dev Package | Official SDK | OSS Status |
| --- | --- | --- | --- |
| Socket.IO | `socket_io_client` | No (third-party) | Included |

Adapters for these providers may live as separate packages; if a provider package is not present in this repo, it is considered planned or maintained in a dedicated repo.

## Vendor Profiles (Docs-Only)

These are recommended stacks for teams that prefer a cloud-vendor mental model. They are **not** provider packages and do **not** appear in the registry.

- **Generic profile**
  - Socket.IO -> `ds_websocket_socket_io`

## Not in OSS (SaaS or community-driven)

- Managed real-time gateways (Pusher, Ably)
- Vendor-specific websocket services

## Provider Contract

Providers implement the shared interface from `ds_websocket_base` and are registered with `DSWebSocketManager`.

---

If you plan to publish a provider, ensure it includes:
- `pubspec.yaml` with `sdk: ^3.10.8`
- `LICENSE` (DartStream standard)
- `CHANGELOG.md`
- `manifest.yaml` for registry/discovery
