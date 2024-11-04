// ds_error_handling.dart

/// Custom exception for handling errors specific to Dartstream extensions.
class DartstreamExtensionException implements Exception {
  final String message;
  DartstreamExtensionException(this.message);

  @override
  String toString() => 'DartstreamExtensionException: $message';
}

/// Utility function for error handling
void handleError(Exception error) {
  print('An error occurred: $error');
}
