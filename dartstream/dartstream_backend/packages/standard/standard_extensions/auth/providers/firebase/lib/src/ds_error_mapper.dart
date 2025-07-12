import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:# ds_auth_base/# ds_auth_base_export.dart';

/// Maps Firebase Admin Auth errors to DartStream errors
class DSFirebaseErrorMapper {
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

    // Handle Firebase Auth exceptions
    if (error is FirebaseAuthException) {
      final errorCode = _mapErrorCode(error.code);
      final errorMessage = _getErrorMessage(error.code);

      return DSAuthError(errorMessage, code: int.tryParse(errorCode) ?? 0);
    }

    // Handle unknown errors
    return DSAuthError(
      'An unexpected error occurred: ${error.toString()}',
      code: 500,
    );
  }

  static String _mapErrorCode(String firebaseCode) {
    final Map<String, String> errorCodeMap = {
      'user-not-found': 'auth/user-not-found',
      'invalid-credential': 'auth/invalid-credentials',
      'email-already-exists': 'auth/email-taken',
      'invalid-password': 'auth/weak-password',
      'invalid-email': 'auth/invalid-email',
      'operation-not-allowed': 'auth/operation-not-allowed',
      'user-disabled': 'auth/user-disabled',
    };

    return errorCodeMap[firebaseCode] ?? 'auth/unknown-error';
  }

  static String _getErrorMessage(String firebaseCode) {
    final Map<String, String> errorMessages = {
      'user-not-found': 'No user found with these credentials',
      'invalid-credential': 'Invalid credentials provided',
      'email-already-exists': 'Email address is already in use',
      'invalid-password': 'Password is invalid or too weak',
      'invalid-email': 'Invalid email address format',
      'operation-not-allowed': 'Operation is not allowed',
      'user-disabled': 'User account has been disabled',
    };

    return errorMessages[firebaseCode] ?? 'An authentication error occurred';
  }
}
