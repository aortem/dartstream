// js_import.dart
/// This library provides an unconditioned wrapper for the `dart:js` library.
///
/// Purpose:
/// - It is used to manage conditional imports in a build system that doesn't
///   allow direct conditional imports of `dart:js`.
///
/// How it works:
/// - Instead of directly importing `dart:js` in production code,
///   this library is imported conditionally using the `if (dart.library.js)`
///   syntax.
/// - If the environment does not support `dart:js`, a stub implementation
///   (`stub_js.dart`) will be used instead.
///
/// Usage:
/// - Import `js_import.dart` conditionally via `conditional_imports.dart`.
///
/// Example:
/// ```dart
/// export '../src/js_import.dart' if (dart.library.js) '../src/stub_js.dart';
/// ```
library js_import;

import 'dart:js';
export 'dart:js';
