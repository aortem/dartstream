// auth/providers/ping/lib/src/ds_error_mapper.dart

import 'package:ds_auth_base/ds_auth_base_export.dart';

/// Maps Ping Identity specific errors to DSAuthError
class DSPingErrorMapper {
  // Error code constants
  static const int errorInvalidCredentials = 401;
  static const int errorUserNotFound = 404;
  static const int errorUserExists = 409;
  static const int errorWeakPassword = 400;
  static const int errorInvalidToken = 401;
  static const int errorTokenExpired = 401;
  static const int errorNoSession = 401;
  static const int errorNetworkError = 503;
  static const int errorUnknown = 500;

  /// Map error codes and messages to DSAuthError
  DSAuthError mapError(String errorCode, String message) {
    switch (errorCode) {
      case 'INVALID_CREDENTIALS':
        return DSAuthError(
          'Invalid username or password',
          code: errorInvalidCredentials,
        );
      
      case 'USER_NOT_FOUND':
        return DSAuthError(
          'User not found',
          code: errorUserNotFound,
        );
      
      case 'USER_EXISTS':
        return DSAuthError(
          'User with this email already exists',
          code: errorUserExists,
        );
      
      case 'WEAK_PASSWORD':
        return DSAuthError(
          'Password does not meet security requirements',
          code: errorWeakPassword,
        );
      
      case 'INVALID_TOKEN':
        return DSAuthError(
          'Invalid or malformed token',
          code: errorInvalidToken,
        );
      
      case 'TOKEN_EXPIRED':
        return DSAuthError(
          'Token has expired',
          code: errorTokenExpired,
        );
      
      case 'NO_SESSION':
        return DSAuthError(
          'No active session found',
          code: errorNoSession,
        );
      
      case 'NETWORK_ERROR':
        return DSAuthError(
          'Network error occurred',
          code: errorNetworkError,
        );
      
      case 'SIGN_IN_FAILED':
        return DSAuthError(
          'Sign in failed: $message',
          code: errorUnknown,
        );
      
      case 'SIGN_OUT_FAILED':
        return DSAuthError(
          'Sign out failed: $message',
          code: errorUnknown,
        );
      
      case 'GET_USER_FAILED':
        return DSAuthError(
          'Failed to retrieve user: $message',
          code: errorUnknown,
        );
      
      case 'GET_CURRENT_USER_FAILED':
        return DSAuthError(
          'Failed to retrieve current user: $message',
          code: errorUnknown,
        );
      
      case 'REFRESH_TOKEN_FAILED':
        return DSAuthError(
          'Failed to refresh token: $message',
          code: errorUnknown,
        );
      
      case 'CREATE_ACCOUNT_FAILED':
        return DSAuthError(
          'Failed to create account: $message',
          code: errorUnknown,
        );
      
      default:
        return DSAuthError(
          'Unknown error: $message',
          code: errorUnknown,
        );
    }
  }

  /// Map HTTP status codes to error messages
  DSAuthError mapHttpError(int statusCode, String? body) {
    switch (statusCode) {
      case 400:
        return DSAuthError(
          'Bad request: ${body ?? "Invalid request parameters"}',
          code: 400,
        );
      
      case 401:
        return DSAuthError(
          'Unauthorized: ${body ?? "Authentication required"}',
          code: 401,
        );
      
      case 403:
        return DSAuthError(
          'Forbidden: ${body ?? "Access denied"}',
          code: 403,
        );
      
      case 404:
        return DSAuthError(
          'Not found: ${body ?? "Resource not found"}',
          code: 404,
        );
      
      case 409:
        return DSAuthError(
          'Conflict: ${body ?? "Resource already exists"}',
          code: 409,
        );
      
      case 429:
        return DSAuthError(
          'Too many requests: ${body ?? "Rate limit exceeded"}',
          code: 429,
        );
      
      case 500:
        return DSAuthError(
          'Internal server error: ${body ?? "Server error occurred"}',
          code: 500,
        );
      
      case 503:
        return DSAuthError(
          'Service unavailable: ${body ?? "Service temporarily unavailable"}',
          code: 503,
        );
      
      default:
        return DSAuthError(
          'HTTP error $statusCode: ${body ?? "Unknown error"}',
          code: statusCode,
        );
    }
  }

  /// Check if error is retryable
  bool isRetryableError(DSAuthError error) {
    if (error.code == null) return false;
    
    // Network errors and service unavailable are retryable
    return error.code == errorNetworkError || error.code == 503 || error.code == 429;
  }

  /// Get user-friendly error message
 String getUserFriendlyMessage(DSAuthError error) {
  if (error.code == null) return error.message;

  // All 401-based auth/session issues
  if (error.code == 401) {
    return 'Your session is invalid or has expired. Please sign in again.';
  }

  switch (error.code) {
    case errorUserNotFound:
      return 'We couldn\'t find an account with that information.';

    case errorUserExists:
      return 'An account with this email already exists.';

    case errorWeakPassword:
      return 'Please choose a stronger password.';

    case errorNetworkError:
      return 'Unable to connect. Please check your internet connection.';

    default:
      return 'Something went wrong. Please try again.';
  }
}


}
