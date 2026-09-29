# ds_DartStream_standard_engine

The **DartStream Standard Core Engine** (`DSStandardCore`) is the core foundation for the DartStream framework.
It provides centralized configuration, service management, lifecycle-aware extension handling, and debugging utilities for DartStream applications.

---

## Features

Release checks include this package's own archive validation and test dependencies on Dart 3.13.4.

- Core configuration management
- Service registration and retrieval
- Lifecycle-aware core extension registration
- Support for extended features
- Debugging and inspection utilities

---

## Installation

Add the package to your project:

```bash
dart pub add ds_DartStream_standard_engine

## Release dependencies

Publish `ds_lifecycle_base` 0.0.2 before the engine packages. The engine 0.0.3
release includes the lifecycle import required by standalone consumers.
Validated with Dart 3.13.4; minimum Dart 3.12.2 is retained.
