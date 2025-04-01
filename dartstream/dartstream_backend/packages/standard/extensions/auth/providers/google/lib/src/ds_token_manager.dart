/// Manages authentication tokens for the Firebase provider
class DSTokenManager {
  // Store tokens with expiration
  final Map<String, _TokenInfo> _tokens = {};

  /// Stores a new token with expiration
  Future<void> storeToken(String userId, String token,
      {int expiresIn = 3600}) async {
    _tokens[userId] = _TokenInfo(
      token: token,
      expirationTime: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }

  /// Retrieves a valid token, returns null if expired
  Future<String?> getToken(String userId) async {
    final tokenInfo = _tokens[userId];
    if (tokenInfo != null && tokenInfo.isValid) {
      return tokenInfo.token;
    }
    return null;
  }

  /// Refreshes an existing token
  Future<void> refreshToken(String userId, String newToken,
      {int expiresIn = 3600}) async {
    await storeToken(userId, newToken, expiresIn: expiresIn);
  }

  /// Removes a token
  Future<void> removeToken(String userId) async {
    _tokens.remove(userId);
  }

  /// Clears all stored tokens
  Future<void> clearTokens() async {
    _tokens.clear();
  }

  /// Validates a token format and expiration
  bool isTokenValid(String token) {
    // Add Firebase-specific token validation logic
    return token.isNotEmpty && token.split('.').length == 3;
  }
}

class _TokenInfo {
  final String token;
  final DateTime expirationTime;

  _TokenInfo({required this.token, required this.expirationTime});

  bool get isValid => DateTime.now().isBefore(expirationTime);
}
