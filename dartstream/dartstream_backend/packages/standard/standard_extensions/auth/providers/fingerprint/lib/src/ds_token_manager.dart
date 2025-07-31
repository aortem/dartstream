import 'dart:convert';

/// Manages authentication tokens for the Fingerprint provider
class DSTokenManager {
  final Map<String, _TokenInfo> _tokens = {};

  Future<void> storeToken(String userId, String token, {int? expiresIn}) async {
    final expiry = expiresIn != null
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : getTokenExpiration(token) ?? DateTime.now().add(Duration(hours: 1));

    _tokens[userId] = _TokenInfo(token: token, expirationTime: expiry);
  }

  Future<String?> getToken(String userId) async {
    final tokenInfo = _tokens[userId];
    if (tokenInfo != null && tokenInfo.isValid) {
      return tokenInfo.token;
    }
    return null;
  }

  Future<void> refreshToken(
    String userId,
    String newToken, {
    int? expiresIn,
  }) async {
    await storeToken(userId, newToken, expiresIn: expiresIn);
  }

  Future<void> removeToken(String userId) async {
    _tokens.remove(userId);
  }

  Future<void> clearTokens() async {
    _tokens.clear();
  }

  Map<String, String> getActiveTokens() {
    final activeTokens = <String, String>{};
    _tokens.forEach((userId, tokenInfo) {
      if (tokenInfo.isValid) {
        activeTokens[userId] = tokenInfo.token;
      }
    });
    return activeTokens;
  }

  DateTime? getTokenExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64.normalize(parts[1]))),
      );
      final exp = payload['exp'] as int?;
      if (exp != null) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (e) {
      // Token parsing failed
    }
    return null;
  }

  bool isTokenExpired(String token) {
    final expiration = getTokenExpiration(token);
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }

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
