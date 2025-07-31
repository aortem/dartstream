class DSTransmitTokenManager {
  String? accessToken;

  void saveToken(String token) {
    accessToken = token;
  }
  
  String? getToken() {
    return accessToken;
  }

  void clearToken() {
    accessToken = null;
  }

  // Add refresh logic if Transmit supports it
}
