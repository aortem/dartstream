# Changelog

## [0.0.1]
### Added
- First main OSS release of the backend meta-package and workspace wiring.
- Lean OSS persistence providers: PostgreSQL, MongoDB, Firestore; AWS S3-compatible and GCP Storage; OTLP and Sentry logging.
- Reactive dataflow modules: message broker base + GCP Pub/Sub provider; WebSocket base + Socket.IO provider; events and notifications bases.
- Standard engine and extensions umbrella exports plus refreshed registry manifests for discovery.
- CLI tooling packages and commands for init, setup, discovery, enable/disable, generate, and validate.
- Registry tooling scripts and a dev server example (`bin/generate_registry.dart`, `bin/sync_manifest.dart`, `bin/dev_server.dart`).
- Configuration templates for development/production middleware and registered extension manifests.
- Backend root LICENSE (BSD-3 with ELv2 for service integrations).

### Changed
- Standardized provider package naming to `*_provider` and updated docs/vendor profiles to match.
- Updated SDK constraints to `^3.10.9` and bumped key deps (`googleapis ^15.0.0`, `googleapis_auth ^2.0.0`, `ds_standard_features ^0.1.6`).
- Updated backend meta-package dependencies/workspace list to include new and renamed providers.

### Fixed
- Resolved self-export loops in umbrella exports and removed placeholder configs.
- Added missing `_discoveryapis_commons` dependency for the GCP storage provider.

## [0.0.1-pre+3]
- Remove remaining code from depreacted packages
- Update ds_testing_tools package to .0.0.2
- ds_database_provider.dart - Core interface for all database providers with CRUD operations
- ds_database_manager.dart - Central registry for database providers
- ds_database_base.dart - Consolidates exports for easier importing Providers:
- ds_firebase_database.dart - Google Cloud Firestore implementation
- ds_postgres_database.dart - PostgreSQL implementation
- ds_mysql_database.dart - MySQL implementation Configuration:
- manifest.yaml files - Provider metadata for extension registration
- pubspec.yaml files - Package dependencies for each provider
- updated cloud DB with open source for google and also added pubspec and manifest to workspace folders
- Maintained the base folder with core interfaces
- Reorganized database providers under providers/google/ directory
- Fixed bugs in MySQL transaction implementation
- Updated import paths in all database files
- Ensured consistent error handling across providers

## [0.0.1-pre+2]
- update shelf package depedencies for ds_shelf Middleware
- update ds pre-fix for standard classes
- remove non essential components like cicd and cloud vendor configs
- Add registration requirements for extensions
- Add authentication SDK vendors
- Add test packages for coverage
- Add extension discovery registration system
- Update Discovery command for consistency
- Remove deprecated CLI tooling packages

## [0.0.1-pre+1]
- Initial version.

