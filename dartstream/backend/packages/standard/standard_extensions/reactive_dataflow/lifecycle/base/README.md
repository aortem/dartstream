# DartStream Lifecycle Base

Provider-neutral lifecycle hooks and adapters for DartStream packages.

This package defines the core lifecycle contracts used by extensions and runtime
modules to react to startup, shutdown, and operational lifecycle events without
depending on a specific provider implementation.

## Usage

Import the package and implement the lifecycle hook contracts for your package or
extension:

```dart
import 'package:ds_lifecycle_base/ds_lifecycle_base.dart';
```

## Package Role

`ds_lifecycle_base` is a foundational DartStream contract package. Provider and
extension packages should depend on this package when they need shared lifecycle
semantics.
