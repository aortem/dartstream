import 'package:ds_auth_base/ds_auth_base_export.dart';

/// Maps Magic Auth errors to DartStream errors
class DSMagicErrorMapper {
  static DSAuthError mapError(dynamic error) {
    print('Mapping error: $error');

    // Handle string errors (like initialization errors)
    if (error is String) {
      if (error.contains('not initialized')) {
        return DSAuthError(
          'Authentication service is not properly initialized. Please try again.',
          code: 500,
        );
      }
      return DSAuthError(error);
    }

    // TODO: Handle Magic-specific error objects/codes here

    // Handle unknown errors
    return DSAuthError(
      'An unexpected error occurred: {error.toString()}',
      code: 500,
    );
  }
}
