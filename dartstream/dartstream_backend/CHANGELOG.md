## 0.0.1-pre+4

### Added
- update tool and dartstream structure


## 0.0.1-pre+3

- Remove remaining code from depreacted packages
- Update ds_testing_tools package to .0.0.2
- ds_database_provider.dart - Core interface for all database providers with CRUD operations
- ds_database_manager.dart - Central registry for database providers
- ds_database_base_export.dart - Consolidates exports for easier importing Providers:
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

## 0.0.1-pre+2

- update shelf package depedencies for ds_shelf Middleware
- update ds pre-fix for standard classes
- remove non essential components like cicd and cloud vendor configs
- Add registration requirements for extensions
- Add authentication SDK vendors
- Add test packages for coverage
- Add extension discovery registration system
- Update Discovery command for consistency
- Remove deprecated CLI tooling packages

## .0.0.1-pre+1

- Initial version.
