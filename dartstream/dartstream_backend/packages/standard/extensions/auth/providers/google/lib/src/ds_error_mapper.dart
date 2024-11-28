import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

/// Maps Firebase Auth errors to DartStream errors
class DSFirebaseErrorMapper {
  static DSAuthError mapError(FirebaseAuthException error) {
    final errorCode = _mapErrorCode(error.code);
    final errorMessage = _getErrorMessage(error.code);

    return DSAuthError(
      code: errorCode,
      message: errorMessage,
      originalError: error,
    );
  }

  static String _mapErrorCode(String firebaseCode) {
    final Map<String, String> errorCodeMap = {
      'user-not-found': 'auth/user-not-found',
      'wrong-password': 'auth/invalid-credentials',
      'email-already-in-use': 'auth/email-taken',
      'weak-password': 'auth/weak-password',
      'invalid-email': 'auth/invalid-email',
      'operation-not-allowed': 'auth/operation-not-allowed',
      'user-disabled': 'auth/user-disabled',
      'invalid-verification-code': 'auth/invalid-code',
      'invalid-verification-id': 'auth/invalid-verification-id',
      'quota-exceeded': 'auth/quota-exceeded',
      'network-request-failed': 'auth/network-error',
    };

    return errorCodeMap[firebaseCode] ?? 'auth/unknown-error';
  }

  static String _getErrorMessage(String firebaseCode) {
    final Map<String, String> errorMessages = {
      'user-not-found': 'No user found with these credentials',
      'wrong-password': 'Invalid password provided',
      'email-already-in-use': 'Email address is already in use',
      'weak-password': 'Password is too weak',
      'invalid-email': 'Invalid email address format',
      'operation-not-allowed': 'Operation is not allowed',
      'user-disabled': 'User account has been disabled',
      'invalid-verification-code': 'Invalid verification code',
      'invalid-verification-id': 'Invalid verification ID',
      'quota-exceeded': 'Quota has been exceeded',
      'network-request-failed': 'Network request failed',
    };

    return errorMessages[firebaseCode] ?? 'An unknown error occurred';
  }
}

class DSAuthError implements Exception {
  final String code;
  final String message;
  final dynamic originalError;

  DSAuthError({
    required this.code,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'DSAuthError: $message (Code: $code)';
}
