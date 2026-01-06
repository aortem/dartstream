class DSTransmitSessionManager {
  String? currentSessionToken;

  void createSession(String token) {
    currentSessionToken = token;
  }

  void endSession() {
    currentSessionToken = null;
  }

  bool isSessionActive() {
    // Add expiration logic as needed
    return currentSessionToken != null;
  }
}