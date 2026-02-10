# DartStream Storage (ds_storage_base)

Base storage interfaces and provider registration for DartStream.

## OSS Provider Policy

The open-source framework only ships adapters for the most battle-tested and widely adopted storage backends. Vendor-specific adapters that are not strongly maintained in Dart are reserved for the SaaS edition unless community demand justifies OSS support.

## Supported OSS Providers (Lean List)

- **S3-Compatible Storage** (AWS S3, MinIO, Cloudflare R2, DigitalOcean Spaces)
- **Google Cloud Storage (GCS)**

Adapters for these providers may live as separate packages; if a provider package is not present in this repo, it is considered planned or maintained in a dedicated repo.

## Vendor Profiles (Docs-Only)

These are recommended stacks for teams that prefer a cloud-vendor mental model. They are **not** provider packages and do **not** appear in the registry.

- **AWS profile**
  - S3 -> `ds_aws_storage_provider`
- **GCP profile**
  - Cloud Storage -> `ds_gcp_storage_provider`
- **Azure profile**
  - Azure Blob Storage (not in OSS)

## Not in OSS (SaaS or community-driven)

- Azure Blob Storage
- Backblaze B2 (native SDK)

## Provider Contract

Providers implement the shared interface from `ds_storage_base` and are registered with `DSStorageManager`.

---

If you plan to publish a provider, ensure it includes:
- `pubspec.yaml` with `sdk: ^3.10.9`
- `LICENSE` (DartStream standard)
- `CHANGELOG.md`
- `manifest.yaml` for registry/discovery

