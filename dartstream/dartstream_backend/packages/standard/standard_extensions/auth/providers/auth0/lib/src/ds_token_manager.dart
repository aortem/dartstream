/// Token management for Auth0 authentication provider
/// Handles JWT token storage, validation, and lifecycle management
class DSTokenManager {
  final Map<String, String> _tokens = {};
  final Map<String, DateTime> _expiryTimes = {};

  /// Stores a token for a user
  Future<void> storeToken(String userId, String token) async {
    _tokens[userId] = token;
    _expiryTimes[userId] = _extractTokenExpiry(token);
    print('Token stored for user: $userId');
  }

  /// Retrieves a token for a user
  String? getToken(String userId) {
    final token = _tokens[userId];
    if (token != null && !isTokenExpired(userId)) {
      return token;
    }
    return null;
  }

  /// Removes a token for a user
  Future<void> removeToken(String userId) async {
    _tokens.remove(userId);
    _expiryTimes.remove(userId);
    print('Token removed for user: $userId');
  }

  /// Checks if a token is expired
  bool isTokenExpired(String userId) {
    final expiry = _expiryTimes[userId];
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  /// Validates a JWT token format
  bool validateTokenFormat(String token) {
    try {
      final parts = token.split('.');
      return parts.length == 3;
    } catch (e) {
      return false;
    }
  }

  /// Extracts expiry time from JWT token
  DateTime _extractTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return DateTime.now().add(Duration(hours: 1)); // Default 1 hour
      }
      
      // For mock implementation, return 1 hour from now
      return DateTime.now().add(Duration(hours: 1));
    } catch (e) {
      return DateTime.now().add(Duration(hours: 1));
    }
  }

  /// Gets all active tokens
  Map<String, String> getAllTokens() {
    return Map.from(_tokens);
  }

  /// Clears all tokens
  void clearAllTokens() {
    _tokens.clear();
    _expiryTimes.clear();
    print('All tokens cleared');
  }
}
