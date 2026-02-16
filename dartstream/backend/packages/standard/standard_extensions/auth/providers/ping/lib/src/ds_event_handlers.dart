// auth/providers/ping/lib/src/ds_event_handlers.dart

import 'package:ds_auth_base/ds_auth_base_export.dart';

/// Handles authentication events and lifecycle hooks for Ping Identity
class DSPingEventHandlers {
  final List<_EventLog> _eventHistory = [];
  bool enableLogging = false;

  // Event callbacks
  Function(DSAuthUser)? onSignInCallback;
  Function()? onSignOutCallback;
  Function(String userId)? onAccountCreatedCallback;
  Function(Map<String, dynamic> config)? onInitializeCallback;
  Function(DSAuthError error)? onErrorCallback;

  /// Log an event
  void _logEvent(String eventType, Map<String, dynamic>? data) {
    final event = _EventLog(
      eventType: eventType,
      timestamp: DateTime.now(),
      data: data,
    );
    
    _eventHistory.add(event);
    
    if (enableLogging) {
      print('Ping Event: $eventType at ${event.timestamp}');
      if (data != null && data.isNotEmpty) {
        print('  Data: $data');
      }
    }
  }

  /// Handle initialization event
  Future<void> onInitialize(Map<String, dynamic> config) async {
    _logEvent('INITIALIZE', {
      'clientId': config['clientId'],
      'issuer': config['issuer'],
    });
    
    if (onInitializeCallback != null) {
      await onInitializeCallback!(config);
    }
  }

  /// Handle sign in event
  Future<void> onSignIn(DSAuthUser user) async {
    _logEvent('SIGN_IN', {
      'userId': user.id,
      'email': user.email,
    });
    
    if (onSignInCallback != null) {
      await onSignInCallback!(user);
    }
  }

  /// Handle sign out event
  Future<void> onSignOut() async {
    _logEvent('SIGN_OUT', null);
    
    if (onSignOutCallback != null) {
      await onSignOutCallback!();
    }
  }

  /// Handle account created event
  Future<void> onAccountCreated(String userId) async {
    _logEvent('ACCOUNT_CREATED', {
      'userId': userId,
    });
    
    if (onAccountCreatedCallback != null) {
      await onAccountCreatedCallback!(userId);
    }
  }

  /// Handle token refresh event
  Future<void> onTokenRefresh(String oldToken, String newToken) async {
    _logEvent('TOKEN_REFRESH', {
      'oldToken': _maskToken(oldToken),
      'newToken': _maskToken(newToken),
    });
  }

  /// Handle token verification event
  Future<void> onTokenVerify(String token, bool isValid) async {
    _logEvent('TOKEN_VERIFY', {
      'token': _maskToken(token),
      'isValid': isValid,
    });
  }

  /// Handle error event
  Future<void> onError(DSAuthError error) async {
    _logEvent('ERROR', {
      'message': error.message,
      'code': error.code,
    });
    
    if (onErrorCallback != null) {
      await onErrorCallback!(error);
    }
  }

  /// Handle session created event
  Future<void> onSessionCreated(String userId, String sessionId) async {
    _logEvent('SESSION_CREATED', {
      'userId': userId,
      'sessionId': sessionId,
    });
  }

  /// Handle session destroyed event
  Future<void> onSessionDestroyed(String sessionId) async {
    _logEvent('SESSION_DESTROYED', {
      'sessionId': sessionId,
    });
  }

  /// Get event history
  List<_EventLog> getEventHistory({String? eventType}) {
    if (eventType == null) {
      return List.from(_eventHistory);
    }
    
    return _eventHistory
        .where((event) => event.eventType == eventType)
        .toList();
  }

  /// Get event count by type
  int getEventCount(String eventType) {
    return _eventHistory
        .where((event) => event.eventType == eventType)
        .length;
  }

  /// Clear event history
  void clearHistory() {
    _eventHistory.clear();
  }

  /// Mask sensitive token data for logging
  String _maskToken(String token) {
    if (token.length <= 8) return '***';
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  /// Get last event of specific type
  _EventLog? getLastEvent(String eventType) {
    final events = _eventHistory
        .where((event) => event.eventType == eventType)
        .toList();
    
    return events.isEmpty ? null : events.last;
  }

  /// Check if event occurred within time window
  bool hasEventOccurred(String eventType, Duration within) {
    final cutoff = DateTime.now().subtract(within);
    
    return _eventHistory.any((event) =>
        event.eventType == eventType && event.timestamp.isAfter(cutoff));
  }
}

/// Internal event log structure
class _EventLog {
  final String eventType;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  _EventLog({
    required this.eventType,
    required this.timestamp,
    this.data,
  });

  @override
  String toString() {
    return 'Event($eventType at $timestamp${data != null ? ' - $data' : ''})';
  }
}