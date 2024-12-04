// html_import.dart

/// This file manages conditional imports for platform-specific Dart libraries.
///
/// Purpose:
/// - The Dart build system (e.g., `build_runner`) does not allow direct
///   conditional imports of `dart:` libraries such as `dart:html` and `dart:js`.
/// - To resolve this, `html_import.dart` and `js_import.dart` act as intermediary
///   wrappers, and this file exports them conditionally.
///
/// How it works:
/// - If the platform supports `dart:html`, the `html_import.dart` library is used.
/// - If not, the stub implementation `stub_html.dart` is used.
/// - Similarly, `dart:js` functionality is handled using `js_import.dart` and
///   `stub_js.dart`.
///
/// Usage:
/// - Include `conditional_imports.dart` in files where conditional logic for
///   `dart:html` or `dart:js` is required.
///
/// Example:
/// ```dart
/// import 'package:your_package_name/mocks/conditional_imports.dart';
/// ```
export '../../lib/src/html_import.dart' if (dart.library.html) '../src/stub_html.dart';
export '../../lib/src/js_import.dart' if (dart.library.js) '../src/stub_js.dart';
