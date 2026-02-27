class DSFlagdErrorMapper {
  static DSFlagdException mapError(dynamic error) {
    if (error is DSFlagdException) return error;
    final message = error.toString().toLowerCase();

    if (message.contains('timeout')) {
      return const DSFlagdException(
        code: 'timeout',
        message: 'flagd request timed out.',
      );
    }
    if (message.contains('connection') || message.contains('socket')) {
      return const DSFlagdException(
        code: 'network_error',
        message: 'Unable to connect to flagd.',
      );
    }
    if (message.contains('invalid_response')) {
      return const DSFlagdException(
        code: 'invalid_response',
        message: 'flagd returned an invalid response payload.',
      );
    }

    return DSFlagdException(
      code: 'unknown_error',
      message: 'Unexpected flagd error: ${error.toString()}',
    );
  }
}

class DSFlagdException implements Exception {
  const DSFlagdException({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  @override
  String toString() => 'DSFlagdException($code): $message';
}
