# Testing Guidelines

This project uses `ds_tools_testing` for all testing needs. This ensures consistency across the DartStream framework and leverages Aortem's standard testing utilities.

## Setup

Ensure you have the following dev dependency in your `pubspec.yaml`:

```yaml
dev_dependencies:
  ds_tools_testing: ^0.1.4
```

## Naming Conventions

- Test files should be placed in the `test/` directory.
- Test files must end with `_test.dart`.
- Group tests logically by feature or component.

## Writing Tests

Use the standard `test` and `group` functions exported by `ds_tools_testing`.

```dart
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Component Name', () {
    setUp(() {
      // Setup code
    });

    test('should behave as expected', () {
      // Test logic
      expect(actual, equals(expected));
    });
  });
}
```

## Running Tests

Run all tests using the standard Dart command:

```bash
dart test
```

To run a specific test file:

```bash
dart test test/path/to/file_test.dart
```

## Coverage

We aim for high test coverage. Ensure that:

- All public API methods are covered.
- Edge cases (null inputs, empty lists, error conditions) are tested.
- Custom logic (like TypeHandlers) is verified.
