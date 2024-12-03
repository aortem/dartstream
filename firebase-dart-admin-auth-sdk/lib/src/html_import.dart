// html_import.dart
/// This library provides an unconditioned wrapper for the `dart:html` library.
///
/// Purpose:
/// - It is used to manage conditional imports in a build system that doesn't
///   allow direct conditional imports of `dart:html`.
///
/// How it works:
/// - Instead of directly importing `dart:html` in production code,
///   this library is imported conditionally using the `if (dart.library.html)`
///   syntax.
/// - If the environment does not support `dart:html`, a stub implementation
///   (`stub_html.dart`) will be used instead.
///
/// Usage:
/// - Import `html_import.dart` conditionally via `conditional_imports.dart`.
///
/// Example:
/// ```dart
/// export '../src/html_import.dart' if (dart.library.html) '../src/stub_html.dart';
/// ```
library html_import;

import 'dart:html';
export 'dart:html';
