/// Handles Auth0 Authentication events and maps them to DartStream events
class DSAuth0EventHandler {
  final void Function(DSAuthEvent) onEvent;

  DSAuth0EventHandler({required this.onEvent});

  void initialize() {
    // Auth0 doesn't have built-in event streams like Firebase
    // Events are triggered manually in the provider
    print('Auth0 Event Handler initialized');
  }

  /// Emits an event with the given type and data
  void emitEvent(DSAuthEventType type, Map<String, dynamic> data) {
    onEvent(DSAuthEvent(type: type, data: data));
  }

  void handleSignIn(Map<String, dynamic> userInfo) {
    onEvent(DSAuthEvent(
      type: DSAuthEventType.signedIn,
      data: {
        'userId': userInfo['sub'],
        'email': userInfo['email'],
        'isNewUser': userInfo['email_verified'] == false,
        'provider': 'auth0',
      },
    ));
  }

  void handleSignOut() {
    onEvent(DSAuthEvent(
      type: DSAuthEventType.signedOut,
      data: {
        'provider': 'auth0',
      },
    ));
  }

  void handleTokenRefresh(String newToken, String userId) {
    onEvent(DSAuthEvent(
      type: DSAuthEventType.tokenRefreshed,
      data: {
        'userId': userId,
        'token': newToken,
        'provider': 'auth0',
      },
    ));
  }

  void handleUserUpdate(Map<String, dynamic> userInfo) {
    onEvent(DSAuthEvent(
      type: DSAuthEventType.userUpdated,
      data: {
        'userId': userInfo['sub'],
        'email': userInfo['email'],
        'provider': 'auth0',
        'updates': userInfo,
      },
    ));
  }

  void handleError(dynamic error) {
    onEvent(DSAuthEvent(
      type: DSAuthEventType.error,
      data: {
        'error': error.toString(),
        'provider': 'auth0',
      },
    ));
  }
}

/// Represents a DartStream authentication event
class DSAuthEvent {
  final DSAuthEventType type;
  final Map<String, dynamic> data;

  DSAuthEvent({required this.type, required this.data});
}

/// Types of authentication events in DartStream
enum DSAuthEventType {
  signedIn,
  signedOut,
  tokenRefreshed,
  userUpdated,
  error,
}
