class DSTokenManager {
  final Map<String, String> _tokens = {};

  String issueToken(String userId) {
    final token = 'stytch-mock-$userId';
    _tokens[token] = userId;
    return token;
  }

  bool verify(String token) => _tokens.containsKey(token);

  void revokeTokens(String userId) {
    _tokens.removeWhere((_, v) => v == userId);
  }
}
