import 'package:ds_auth_base/ds_auth_base_export.dart';

/// Maps Auth0 errors to DartStream errors
class DSAuth0ErrorMapper {
  static DSAuthError mapError(dynamic error) {
    print('Mapping Auth0 error: $error');

    // Handle string errors (like initialization errors)
    if (error is String) {
      if (error.contains('not initialized')) {
        return DSAuthError(
          'Auth0 authentication service is not properly initialized. Please try again.',
          code: 500,
        );
      }
      if (error.contains('invalid_grant')) {
        return DSAuthError(
          'Invalid credentials provided. Please check your username and password.',
          code: 401,
        );
      }
      if (error.contains('access_denied')) {
        return DSAuthError(
          'Access denied. Please check your permissions.',
          code: 403,
        );
      }
      return DSAuthError(error);
    }

    // Handle HTTP errors from Auth0 API
    if (error is Exception) {
      final errorString = error.toString();
      
      if (errorString.contains('401')) {
        return DSAuthError(
          'Authentication failed. Please check your credentials.',
          code: 401,
        );
      }
      if (errorString.contains('403')) {
        return DSAuthError(
          'Access forbidden. Please check your permissions.',
          code: 403,
        );
      }
      if (errorString.contains('429')) {
        return DSAuthError(
          'Too many requests. Please try again later.',
          code: 429,
        );
      }
      if (errorString.contains('500')) {
        return DSAuthError(
          'Auth0 server error. Please try again later.',
          code: 500,
        );
      }
    }

    // Handle Auth0-specific errors
    if (error is Map<String, dynamic>) {
      final errorCode = error['error'] as String?;
      final errorDescription = error['error_description'] as String?;
      
      return DSAuthError(
        errorDescription ?? 'Auth0 error occurred',
        code: _mapAuth0ErrorCode(errorCode),
      );
    }

    // Handle unknown errors
    return DSAuthError(
      'An unexpected Auth0 error occurred: ${error.toString()}',
      code: 500,
    );
  }

  static int _mapAuth0ErrorCode(String? auth0Code) {
    final Map<String, int> errorCodeMap = {
      'invalid_grant': 401,
      'invalid_client': 401,
      'invalid_request': 400,
      'unsupported_grant_type': 400,
      'access_denied': 403,
      'unauthorized_client': 401,
      'invalid_scope': 400,
      'server_error': 500,
      'temporarily_unavailable': 503,
    };

    return errorCodeMap[auth0Code] ?? 500;
  }

  static String _getErrorMessage(String? auth0Code) {
    final Map<String, String> errorMessageMap = {
      'invalid_grant': 'Invalid credentials provided',
      'invalid_client': 'Invalid client credentials',
      'invalid_request': 'Invalid request format',
      'unsupported_grant_type': 'Unsupported grant type',
      'access_denied': 'Access denied',
      'unauthorized_client': 'Client is not authorized',
      'invalid_scope': 'Invalid scope requested',
      'server_error': 'Auth0 server error',
      'temporarily_unavailable': 'Service temporarily unavailable',
    };

    return errorMessageMap[auth0Code] ?? 'Unknown Auth0 error';
  }
}
