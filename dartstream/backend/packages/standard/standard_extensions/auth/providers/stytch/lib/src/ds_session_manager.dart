class DSSessionManager {
  final Set<String> _activeSessions = {};

  void startSession(String userId) {
    _activeSessions.add(userId);
  }

  void endSession(String userId) {
    _activeSessions.remove(userId);
  }

  bool isActive(String userId) {
    return _activeSessions.contains(userId);
  }
}
