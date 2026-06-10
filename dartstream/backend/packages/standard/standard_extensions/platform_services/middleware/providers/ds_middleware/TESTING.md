# Testing Guidelines

This project uses `ds_tools_testing` and `mocktail` to ensure high code quality. These guidelines align with the DartStream framework's "Super-high test coverage" standards.

## 1. Setup

Ensure your `pubspec.yaml` includes the necessary dev dependencies:

```yaml
dev_dependencies:
  ds_tools_testing: ^0.1.5
  mocktail: ^1.0.3
```

## 2. Directory Structure

Organize tests to clearly separate unit logic from integration flows:

```
test/
├── unit/             # Isolated tests for classes/functions
│   ├── routing/
│   ├── type_handlers/
│   └── example_unit_test.dart
├── integration/      # Tests involving multiple components
│   ├── middleware/
│   └── example_integration_test.dart
```

## 3. Writing Tests

### Unit Tests

Test a single class or function in isolation. Use `mocktail` to simulate dependencies. **Recommendation**: Use a prefix (e.g., `import ... as mt`) to avoid conflicts with `ds_tools_testing`.

**Example:**
See [test/unit/example_unit_test.dart](test/unit/example_unit_test.dart).

```dart
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockDatabase extends mt.Mock implements Database {}

test('returns user name', () async {
  final mockDb = MockDatabase();
  mt.when(() => mockDb.getUser('123')).thenAnswer((_) async => 'Alice');

  final service = UserService(mockDb);
  expect(await service.getUserName('123'), equals('Alice'));
});
```

### Integration Tests

Test how components interact, such as a request passing through middleware strings.

**Example:**
See [test/integration/example_integration_test.dart](test/integration/example_integration_test.dart).

```dart
test('middleware adds header', () async {
  final pipeline = Pipeline().addMiddleware(myMiddleware).addHandler(myHandler);
  final response = await pipeline(Request(...));
  expect(response.headers['X-Custom'], equals('Value'));
});
```

## 4. Running Tests

Run all tests:

```bash
dart test
```

Run only unit tests:

```bash
dart test test/unit
```

Run only integration tests:

```bash
dart test test/integration
```
