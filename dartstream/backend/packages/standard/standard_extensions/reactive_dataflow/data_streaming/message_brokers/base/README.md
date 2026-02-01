# DartStream Message Brokers (ds_message_broker_base)

Base message broker interfaces and provider registration for DartStream.

## OSS Provider Policy

The open-source framework only ships adapters for the most battle-tested and widely adopted message brokers. Vendor-specific adapters that are not strongly maintained in Dart are reserved for the SaaS edition unless community demand justifies OSS support.

## Supported OSS Providers (Lean List)

| Provider | Pub.dev Package | Official SDK | OSS Status |
| --- | --- | --- | --- |
| Google Cloud Pub/Sub | `googleapis` (Pub/Sub API) | Yes | Included |

Adapters for these providers may live as separate packages; if a provider package is not present in this repo, it is considered planned or maintained in a dedicated repo.

## Vendor Profiles (Docs-Only)

These are recommended stacks for teams that prefer a cloud-vendor mental model. They are **not** provider packages and do **not** appear in the registry.

- **GCP profile**
  - Pub/Sub -> `ds_gcp_pubsub_message_broker_provider`

## Not in OSS (SaaS or community-driven)

- Kafka
- RabbitMQ
- NATS
- Redis Streams

## Provider Contract

Providers implement the shared interface from `ds_message_broker_base` and are registered with `DSMessageBrokerManager`.

---

If you plan to publish a provider, ensure it includes:
- `pubspec.yaml` with `sdk: ^3.10.8`
- `LICENSE` (DartStream standard)
- `CHANGELOG.md`
- `manifest.yaml` for registry/discovery
