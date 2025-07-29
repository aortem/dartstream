# DartStream Transmit Authentication Provider

## Overview

The Transmit provider adds modular authentication capabilities to DartStream, following the same structure and technical approach as the Auth0 and Magic providers.

## Features

- Passwordless or conventional Transmit authentication (based on Transmit API capabilities)
- Token management: secure storage, validation, renewal (if supported)
- Session management: active session tracking and validation
- Lifecycle event hooks: handle login/logout and other authentication events

## Directory Structure
```
transmit/
    lib/
        src/
            ds_error_mapper.dartds_event_handlers.dart
            ds_session_manager.dartds_token_manager.dart
            ds_transmit_auth_export.dart
            ds_transmit_auth_provider.dart
        ds_transmit_auth_export.dart
        ds_transmit_auth_provider.dart
        CHANGELOG.md
        LICENSE
        manifest.yaml
        pubspec.yaml
        README.md
```

## Key Dart Files

- **lib/src/ds_error_mapper.dart**: Maps Transmit-specific errors to standardized DartStream error codes.
- **lib/src/ds_event_handlers.dart**: Handles provider-related authentication events.
- **lib/src/ds_session_manager.dart**: Manages the user session lifecycle.
- **lib/src/ds_token_manager.dart**: Handles access token storage, retrieval, and renewal logic.
- **lib/ds_transmit_auth_export.dart**: Barrel export file for public APIs.
- **lib/ds_transmit_auth_provider.dart**: Transmit-specific provider class with main authentication logic.

## Example Usage
```
import ‘package:transmit/ds_transmit_auth_provider.dart’;
final config = {‘clientId’: ‘your-transmit-client-id’,‘clientSecret’: ‘your-transmit-client-secret’,// Add other config as needed};final transmitProvider = DSTransmitAuthProvider();await transmitProvider.initialize(config);
DSAuthManager.registerProvider(‘transmit’, transmitProvider);
```


## Core API Methods

| Method               | Description                                   |
|----------------------|-----------------------------------------------|
| `initialize(config)` | Provider setup and configuration              |
| `signIn(token)`      | Sign in user using a Transmit token           |
| `signOut()`          | End the current user session                  |
| `getCurrentUser()`   | Retrieve the current authenticated user       |
| `verifyToken(token)` | Validate a given token with Transmit's API    |

## Project Files (Descriptions)

| File                              | Purpose                                    |
|------------------------------------|--------------------------------------------|
| `lib/src/ds_error_mapper.dart`     | Error code mapping logic                   |
| `lib/src/ds_event_handlers.dart`   | Authentication event/lifecycle hooks       |
| `lib/src/ds_session_manager.dart`  | Session state manager                      |
| `lib/src/ds_token_manager.dart`    | Token handling/utilities                   |
| `lib/ds_transmit_auth_export.dart` | Public package exports                     |
| `lib/ds_transmit_auth_provider.dart`| Provider-specific logic                   |
| `CHANGELOG.md`                    | Change tracking for the package            |
| `LICENSE`                         | Usage licensing information                |
| `manifest.yaml`                   | Package meta-information                   |
| `pubspec.yaml`                    | Dart dependency and configuration details  |
| `README.md`                       | Onboarding, architecture, and API guides   |

## Notes

- Follow this structure and modular approach for maintainability and extensibility.
- Ensure all secrets and API keys are securely managed.
- Update dependencies and documentation as Transmit or DartStream evolves.
