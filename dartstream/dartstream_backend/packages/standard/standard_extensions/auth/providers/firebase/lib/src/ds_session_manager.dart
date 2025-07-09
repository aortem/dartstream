/// Manages user sessions for the Firebase provider
class DSSessionManager {
  final Map<String, DSSession> _activeSessions = {};

  /// Creates a new session
  Future<DSSession> createSession({
    required String userId,
    required String deviceId,
    Duration maxAge = const Duration(hours: 24),
  }) async {
    final session = DSSession(
      userId: userId,
      deviceId: deviceId,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(maxAge),
    );

    _activeSessions[userId] = session;
    return session;
  }

  /// Gets an active session
  Future<DSSession?> getSession(String userId) async {
    final session = _activeSessions[userId];
    if (session != null && !session.isExpired) {
      return session;
    }
    return null;
  }

  /// Refreshes an existing session
  Future<DSSession> refreshSession(String userId,
      {Duration? newDuration}) async {
    final existing = _activeSessions[userId];
    if (existing == null) {
      throw SessionNotFoundException('No session found for user: $userId');
    }

    return await createSession(
      userId: userId,
      deviceId: existing.deviceId,
      maxAge: newDuration ?? const Duration(hours: 24),
    );
  }

  /// Removes a specific session
  Future<void> removeSession(String userId) async {
    _activeSessions.remove(userId);
  }

  /// Clears all sessions
  Future<void> clearSessions() async {
    _activeSessions.clear();
  }

  /// Gets all active sessions for monitoring
  List<DSSession> getActiveSessions() {
    return _activeSessions.values
        .where((session) => !session.isExpired)
        .toList();
  }

  /// Gets session count for a user
  int getSessionCount(String userId) {
    return _activeSessions.values
        .where((session) => session.userId == userId && !session.isExpired)
        .length;
  }

  /// Validates session by device ID
  Future<bool> isValidSession(String userId, String deviceId) async {
    final session = _activeSessions[userId];
    return session != null && 
           session.deviceId == deviceId && 
           !session.isExpired;
  }

  /// Extends session duration
  Future<DSSession> extendSession(String userId, {Duration? additionalTime}) async {
    final existing = _activeSessions[userId];
    if (existing == null) {
      throw SessionNotFoundException('No session found for user: $userId');
    }

    final newExpiration = existing.expiresAt.add(
      additionalTime ?? const Duration(hours: 1)
    );

    final extendedSession = DSSession(
      userId: userId,
      deviceId: existing.deviceId,
      createdAt: existing.createdAt,
      expiresAt: newExpiration,
    );

    _activeSessions[userId] = extendedSession;
    return extendedSession;
  }

  /// Cleanup expired sessions
  Future<void> cleanupExpiredSessions() async {
    final expiredKeys = <String>[];
    _activeSessions.forEach((key, session) {
      if (session.isExpired) {
        expiredKeys.add(key);
      }
    });

    for (final key in expiredKeys) {
      _activeSessions.remove(key);
    }
  }

  /// Gets session analytics
  Map<String, dynamic> getSessionAnalytics() {
    final totalSessions = _activeSessions.length;
    final activeSessions = _activeSessions.values
        .where((session) => !session.isExpired)
        .length;
    final expiredSessions = totalSessions - activeSessions;

    return {
      'totalSessions': totalSessions,
      'activeSessions': activeSessions,
      'expiredSessions': expiredSessions,
      'lastCleanup': DateTime.now().toIso8601String(),
    };
  }
}

class DSSession {
  final String userId;
  final String deviceId;
  final DateTime createdAt;
  final DateTime expiresAt;

  DSSession({
    required this.userId,
    required this.deviceId,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class SessionNotFoundException implements Exception {
  final String message;
  SessionNotFoundException(this.message);
}
