/// Session management for Auth0 authentication provider
/// Handles user sessions, device tracking, and session lifecycle
class DSSessionManager {
  final Map<String, DSAuthSession> _sessions = {};
  final Map<String, Set<String>> _userDevices = {};

  /// Creates a new session for a user
  Future<void> createSession({
    required String userId,
    required String deviceId,
  }) async {
    final session = DSAuthSession(
      sessionId: _generateSessionId(),
      userId: userId,
      deviceId: deviceId,
      createdAt: DateTime.now(),
      lastActivity: DateTime.now(),
    );

    _sessions[session.sessionId] = session;
    
    // Track user devices
    _userDevices.putIfAbsent(userId, () => <String>{}).add(deviceId);
    
    print('Session created for user: $userId, device: $deviceId');
  }

  /// Removes a session for a user
  Future<void> removeSession(String userId) async {
    // Remove all sessions for the user
    _sessions.removeWhere((sessionId, session) => session.userId == userId);
    _userDevices.remove(userId);
    print('Sessions removed for user: $userId');
  }

  /// Validates if a session is active
  bool isSessionActive(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) return false;
    
    // Check if session is within valid time window (24 hours)
    final now = DateTime.now();
    final sessionAge = now.difference(session.lastActivity);
    return sessionAge.inHours < 24;
  }

  /// Updates session activity
  void updateSessionActivity(String sessionId) {
    final session = _sessions[sessionId];
    if (session != null) {
      _sessions[sessionId] = session.copyWith(lastActivity: DateTime.now());
    }
  }

  /// Gets session for a user
  DSAuthSession? getSessionForUser(String userId) {
    return _sessions.values.firstWhere(
      (session) => session.userId == userId,
      orElse: () => throw StateError('No session found'),
    );
  }

  /// Gets all active sessions for a user
  List<DSAuthSession> getActiveSessions(String userId) {
    return _sessions.values
        .where((session) => 
            session.userId == userId && 
            isSessionActive(session.sessionId))
        .toList();
  }

  /// Gets device count for a user
  int getDeviceCount(String userId) {
    return _userDevices[userId]?.length ?? 0;
  }

  /// Generates a unique session identifier
  String _generateSessionId() {
    return 'auth0_session_${DateTime.now().millisecondsSinceEpoch}_${_randomString(8)}';
  }

  /// Generates a random string
  String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => 
        chars[DateTime.now().millisecondsSinceEpoch % chars.length])
        .join();
  }

  /// Clears all sessions
  void clearAllSessions() {
    _sessions.clear();
    _userDevices.clear();
    print('All sessions cleared');
  }
}

/// Represents an authentication session
class DSAuthSession {
  final String sessionId;
  final String userId;
  final String deviceId;
  final DateTime createdAt;
  final DateTime lastActivity;

  DSAuthSession({
    required this.sessionId,
    required this.userId,
    required this.deviceId,
    required this.createdAt,
    required this.lastActivity,
  });

  DSAuthSession copyWith({
    String? sessionId,
    String? userId,
    String? deviceId,
    DateTime? createdAt,
    DateTime? lastActivity,
  }) {
    return DSAuthSession(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  @override
  String toString() {
    return 'DSAuthSession(sessionId: $sessionId, userId: $userId, deviceId: $deviceId)';
  }
}
