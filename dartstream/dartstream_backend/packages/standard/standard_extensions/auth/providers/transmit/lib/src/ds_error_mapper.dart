class DSTransmitErrorMapper {
  String mapErrorCode(String transmitError) {
    switch (transmitError) {
      case 'INVALID_TOKEN':
        return 'auth/invalid-token';
      case 'USER_NOT_FOUND':
        return 'auth/user-not-found';
      // Add provider-specific mappings here
      default:
        return 'auth/unknown';
    }
  }
}