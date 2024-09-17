# DartStream Sample App

This sample app demonstrates the usage of DartStream middleware components, including logging and authorization features.

## Testing Logging

The logging functionality uses the `DsLogger` class, which wraps the `logging` package to provide a consistent logging interface.

To test the logging functionality:

1. Open the file `lib/custom_middleware/logger/logger_test.dart`.
2. The `testLogger()` function demonstrates how to use different log levels.
3. Run the app and navigate to the Logger Test screen.
4. Press the "Test Logger" button.
5. Check the console output for log messages. You should see messages with different log levels:
   - Debug (fine)
   - Info
   - Warning
   - Error (severe)

Note: The visibility of log messages may depend on your development environment and logging configuration.

## Testing Authorization

The authorization functionality uses the `DsAuthorization` class, which implements a simple role-based access control system.

To test the authorization functionality:

1. Open the file `lib/custom_middleware/authorization/authorization_test.dart`.
2. The `testAuthorization()` function simulates three scenarios:
   - An authorized request (admin role)
   - An unauthorized request (user role)
   - A request with no role specified
3. Run the app and navigate to the Authorization Test screen.
4. Press the "Test Authorization" button.
5. The test results will be displayed on the screen, showing:
   - An authorized request (admin role) accessing sensitive data (200 OK)
   - An unauthorized request (user role) being denied access (403 Forbidden)
   - A request with no role being denied access (401 Unauthorized)

The test demonstrates:

- Role-based permissions (admin role has 'read_sensitive_data' permission)
- Successful authorization (200 OK status with access granted message)
- Failed authorization due to insufficient permissions (403 Forbidden)
- Failed authorization due to missing role (401 Unauthorized)
