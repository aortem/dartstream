

class DSTokenManager {
  String? _accessToken;
  String? _refreshToken;

  void setTokens({
    required String accessToken,
    String? refreshToken,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool get hasValidToken => _accessToken != null;

  void clear() {
    _accessToken = null;
    _refreshToken = null;
  }
}
