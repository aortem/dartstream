# DartStream Database (ds_database_base)

Base database interfaces and provider registration for DartStream.

## OSS Provider Policy

The open-source framework only ships adapters for the most battle-tested and widely adopted databases. Cloud-vendor specific adapters that are not strongly maintained in Dart are reserved for the SaaS edition unless community demand justifies OSS support.

## Supported OSS Providers (Lean List)

- **PostgreSQL** (via `postgres`)
- **MongoDB / Atlas** (via `mongo_dart`)
- **Google Firestore** (server-side via `googleapis`)

Adapters for these providers may live as separate packages; if a provider package is not present in this repo, it is considered planned or maintained in a dedicated repo.

## Vendor Profiles (Docs-Only)

These are recommended stacks for teams that prefer a cloud-vendor mental model. They are **not** provider packages and do **not** appear in the registry.

- **AWS profile**
  - PostgreSQL (RDS/Aurora) -> `ds_postgres_database`
  - MongoDB (DocumentDB) -> `ds_mongo_database`
- **GCP profile**
  - PostgreSQL (Cloud SQL) -> `ds_postgres_database`
  - Firestore -> `ds_firebase_database`
- **Azure profile**
  - PostgreSQL (Azure Database for PostgreSQL) -> `ds_postgres_database`
  - MongoDB (Cosmos DB Mongo API) -> `ds_mongo_database`

## Not in OSS (SaaS or community-driven)

- MySQL / MariaDB
- DynamoDB
- Azure SQL / MSSQL
- Redis

## Provider Contract

Providers implement the shared interface from `ds_database_base` and are registered with `DSDatabaseManager`.

--- 

If you plan to publish a provider, ensure it includes:
- `pubspec.yaml` with `sdk: ^3.10.9`
- `LICENSE` (DartStream standard)
- `CHANGELOG.md`
- `manifest.yaml` for registry/discovery

