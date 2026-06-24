# Changelog

## 0.0.8

- Restored the hosted `dartstream` executable to the full public command set:
  `init`, `configure`, `setup`, `generate`, `validate`, `extensions`,
  `discover`, `list`, `enable-extension`, `disable-extension`, and `login`.
- Moved the public CLI runner into the published root package so global
  activation does not depend on unpublished workspace-only packages.
- Added hosted-runner tests for command registration, login, init/configure/
  validate, and client generation.

## 0.0.7

- Fixed hosted `dartstream` global activation by keeping the public root
  executable independent from unpublished workspace-only CLI packages.
- Excluded local registry, sync, and dev-server scripts from the published
  package executable set.

## 0.0.6

- Bumped package metadata for the Dart 3.12.2 upgrade pass.
- Updated the Dart SDK constraint to `^3.12.2` for the Dart 3.12 release line.
- Refreshed dependency resolution with the current Dart/Flutter tooling where applicable.

## [0.0.5]
### Fixed
- Limited the hosted `ds_dartstream` global executable contract to the public
  `dartstream` command so pub global activation does not try to compile
  internal helper and development server scripts.
- Restored Windows global activation so `dartstream` shims are created after
  installation.

## [0.0.4]
### Fixed
- Removed the GCP storage provider from the hosted umbrella dependency set so `ds_dartstream` can resolve alongside the GCP Pub/Sub message broker until their `googleapis` ranges are aligned.

## [0.0.3]
### Changed
- Prepared the `ds_dartstream` umbrella package for the next public release.
- Added package publish exclusions for local analysis, release review, Firebase, and frontend build artifacts.
- Kept local-only package artifacts and unpublished providers out of the hosted root package contract.
- Limited the hosted root exports to DartStream packages that are already published on pub.dev.

### Fixed
- Removed stale local review artifacts from the open-source package tree.
- Prevented Dart lockfiles and generated build outputs from being reintroduced into the repository.

## [0.0.2]
### Added
- Added provider-neutral `ds_ai_base` contracts for AI providers, requests, responses, and manager orchestration.
- Added provider-neutral `ds_orm_base` contracts for ORM adapters, repositories, queries, and schema metadata.
- Added the backend `ds_dartstream` umbrella library export for standard engine, auth, persistence, feature flags, middleware, AI, and ORM surfaces.
- Added Open Source Boundary, Package Maturity, Frontend Support, Feature Flags, AI Extensions, and ORM Integration documentation.

### Changed
- Clarified the OSS framework boundary from DartStream SaaS while keeping Aortem open-source support explicit.
- Limited feature flag guidance to IntelliToggle and flagd as supported provider lanes.
- Documented Drift as the first ORM adapter candidate without adding a concrete ORM dependency yet.

### Fixed
- Removed a duplicate Magic auth test outside the package-local test tree.
- Removed a stale middleware conflict artifact and tightened touched middleware CORS/context behavior covered by focused tests.
- Hardened package-specific release automation so development pushes only release packages with changed changelogs.
- Made GitLab release lookups tolerant of non-list API responses.

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
