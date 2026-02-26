/// Maps IntelliToggle and OpenFeature errors to DartStream-compatible exceptions.
///
/// Ensures consistent error handling across the DartStream framework
/// regardless of the underlying feature flag provider.
class DSIntelliToggleErrorMapper {
  /// Maps an error to a [DSIntelliToggleException].
  static DSIntelliToggleException mapError(dynamic error) {
    if (error is DSIntelliToggleException) return error;

    final message = error.toString().toLowerCase();

    if (message.contains('unauthorized') || message.contains('401')) {
      return DSIntelliToggleException(
        code: 'unauthorized',
        message: 'Invalid OAuth2 credentials. Check your clientId, clientSecret, and tenantId.',
      );
    }

    if (message.contains('not found') || message.contains('404')) {
      return DSIntelliToggleException(
        code: 'flag_not_found',
        message: 'Feature flag not found in IntelliToggle.',
      );
    }

    if (message.contains('rate limit') || message.contains('429')) {
      return DSIntelliToggleException(
        code: 'rate_limit_exceeded',
        message: 'IntelliToggle API rate limit exceeded. Try again later.',
      );
    }

    if (message.contains('timeout')) {
      return DSIntelliToggleException(
        code: 'timeout',
        message: 'IntelliToggle API request timed out.',
      );
    }

    if (message.contains('network') || message.contains('socket')) {
      return DSIntelliToggleException(
        code: 'network_error',
        message: 'Network error while connecting to IntelliToggle.',
      );
    }

    if (message.contains('not initialized')) {
      return DSIntelliToggleException(
        code: 'not_initialized',
        message: 'DSIntelliToggleProvider is not initialized. Call initialize() first.',
      );
    }

    return DSIntelliToggleException(
      code: 'unknown_error',
      message: 'An unexpected error occurred: ${error.toString()}',
    );
  }
}

/// Exception class for IntelliToggle-specific errors.
class DSIntelliToggleException implements Exception {
  /// Error code identifying the type of error.
  final String code;

  /// Human-readable error message.
  final String message;

  /// Creates a DSIntelliToggleException.
  const DSIntelliToggleException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'DSIntelliToggleException($code): $message';
}