class DSPingTokenManager {
  String? _accessToken;
  String? _refreshToken;

  void issueTokens(String userId) {
    _accessToken = 'mock-access-token-$userId';
    _refreshToken = 'mock-refresh-token-$userId';
  }

  bool verify(String? token) {
    if (token == null) return false;
    return token == _accessToken;
  }

  String refresh(String refreshToken) {
    if (refreshToken != _refreshToken) {
      throw Exception('Invalid refresh token');
    }
    _accessToken = 'mock-access-token-refreshed';
    return _accessToken!;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }
}
