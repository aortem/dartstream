## 0.0.1

### Added
- Bump SDK 3.9.0

## 0.0.1-pre+4

### Added
- SDK implimentation instead of self built wrapper
- Core implementation of `DSMagicAuthProvider` in `lib/`:
  - **Event handlers** (`lib/src/ds_event_handlers.dart`)
  - **Error mapping** (`lib/src/ds_error_mapper.dart`)
  - **Session management** (`lib/src/ds_session_manager.dart`)
  - **Token management** (`lib/src/ds_token_manager.dart`)
- **Unit tests** covering init, sign‑in, session flows and error cases in  
  `test/standard/extensions/auth/providers/magic/ds_magic_auth_provider_test.dart`
- **Documentation** in `README.md` with setup instructions, API reference, and usage examples.
- Added **LICENSE** (dual BSD‑3 + ELv2) for proper governance.

### Changed
- Bumped Dart **SDK constraint** from `^3.8.1` to `^3.9.0`.
- Switched `ds_auth_base` dependency from a local path to version `^0.0.1-pre`.
- Updated **package description** in `pubspec.yaml`.


## 0.0.1-pre

All notable changes to this project will be documented here.
- Initial Magic provider structure aligned with Auth0 pattern.
- Added event handlers, improved documentation.
