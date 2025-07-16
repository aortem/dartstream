## 0.0.1-pre

### Added
- New Auth0 provider package `ds_auth0_auth_provider` under  
  `packages/standard/standard_extensions/auth/providers/auth0/`
- Export entrypoint:  
  - `lib/ds_auth0_auth_export.dart`
- Core provider implementation:  
  - `lib/ds_auth0_auth_provider.dart` (implements `DSAuthProvider` with full Auth0 flows)
- Utility modules:  
  - `lib/src/ds_token_manager.dart` (JWT storage & expiry)  
  - `lib/src/ds_session_manager.dart` (session & device tracking)  
  - `lib/src/ds_error_mapper.dart` (maps Auth0 errors → `DSAuthError`)  
  - `lib/src/ds_event_handlers.dart` (emits `DSAuthEventType` callbacks)
- Package metadata:  
  - `manifest.yaml` (name, version, entry_point)  
  - `pubspec.yaml` (package version, workspace resolution, deps on `auth0_dart_auth_sdk`, `ds_auth_base`, `ds_standard_features`)



