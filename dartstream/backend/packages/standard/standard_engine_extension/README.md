# DartStream Standard Engine Extension

Core extension contracts for the DartStream standard engine.

This package provides shared extension interfaces that let DartStream modules
integrate with the standard engine while keeping lifecycle and extension behavior
provider-neutral.

## Usage

```dart
import 'package:ds_dartstream_standard_engine_extension/ds_standard_engine_extension.dart';
```

## Package Role

`ds_dartstream_standard_engine_extension` sits between the standard engine and
extension packages. It is part of the public DartStream package graph and should
remain compatible with the published standard engine and lifecycle base
contracts.


## Release dependencies

Publish `ds_lifecycle_base` 0.0.2 before the engine packages. The engine 0.0.3
release includes the lifecycle import required by standalone consumers.
Validated with Dart 3.13.4; minimum Dart 3.12.2 is retained.
