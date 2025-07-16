import 'dart:convert';

/// Manages authentication tokens for the Magic provider
class DSTokenManager {
  // Store tokens with expiration
  final Map<String, _TokenInfo> _tokens = {};

  /// Stores a new token with expiration
  Future<void> storeToken(
    String userId,
    String token, {
    int expiresIn = 3600,
  }) async {
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
  Future<void> refreshToken(
    String userId,
    String newToken, {
    int expiresIn = 3600,
  }) async {
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

  /// Gets all active tokens for debugging purposes
  Map<String, String> getActiveTokens() {
    final activeTokens = <String, String>{};
    _tokens.forEach((userId, tokenInfo) {
      if (tokenInfo.isValid) {
        activeTokens[userId] = tokenInfo.token;
      }
    });
    return activeTokens;
  }

  /// Gets token expiration time (for JWT/DID tokens)
  DateTime? getTokenExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = json.decode(utf8.decode(base64Url.decode(parts[1])));
      final exp = payload['exp'] as int?;
      if (exp != null) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (e) {
      // Token parsing failed
    }
    return null;
  }

  /// Checks if token is expired
  bool isTokenExpired(String token) {
    final expiration = getTokenExpiration(token);
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }

  /// Cleans up expired tokens automatically
  Future<void> cleanupExpiredTokens() async {
    final expiredKeys = <String>[];
    _tokens.forEach((userId, tokenInfo) {
      if (!tokenInfo.isValid) {
        expiredKeys.add(userId);
      }
    });
    for (final key in expiredKeys) {
      _tokens.remove(key);
    }
  }

  /// Validates a token format and expiration (generic JWT/DID)
  bool isTokenValid(String token) {
    return token.isNotEmpty &&
        token.split('.').length == 3 &&
        !isTokenExpired(token);
  }
}

class _TokenInfo {
  final String token;
  final DateTime expirationTime;

  _TokenInfo({required this.token, required this.expirationTime});

  bool get isValid => DateTime.now().isBefore(expirationTime);
}
