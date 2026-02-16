/// Manages fingerprint authentication payloads (opaque tokens)
class DSTokenManager {
  final Map<String, _TokenInfo> _tokens = {};

  Future<void> storeToken(String userId, String token) async {
    _tokens[userId] = _TokenInfo(
      token: token,
      expirationTime: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Future<String?> getToken(String userId) async {
    final info = _tokens[userId];
    if (info != null && info.isValid) {
      return info.token;
    }
    return null;
  }

  Future<void> removeToken(String userId) async {
    _tokens.remove(userId);
  }

  Future<void> clearTokens() async {
    _tokens.clear();
  }

  bool isTokenValid(String token) {
    return token.isNotEmpty;
  }
}

class _TokenInfo {
  final String token;
  final DateTime expirationTime;

  _TokenInfo({
    required this.token,
    required this.expirationTime,
  });

  bool get isValid => DateTime.now().isBefore(expirationTime);
}
