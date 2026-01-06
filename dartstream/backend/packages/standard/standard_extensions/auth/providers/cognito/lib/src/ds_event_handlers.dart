import '../../../../base/lib/ds_auth_provider.dart';

/// Handles Cognito authentication events
class DSCognitoEventHandler {
  final Function(String, Map<String, dynamic>) onEvent;
  bool _isInitialized = false;
  
  DSCognitoEventHandler({required this.onEvent});
  
  /// Initializes the event handler
  void initialize() {
    if (_isInitialized) {
      return;
    }
    
    _isInitialized = true;
    print('Cognito Event Handler initialized');
  }
  
  /// Emits an authentication event
  Future<void> emitEvent(String eventType, Map<String, dynamic> eventData) async {
    if (!_isInitialized) {
      throw DSAuthError('Event handler not initialized');
    }
    
    try {
      // Add timestamp and provider info
      final enrichedData = {
        ...eventData,
        'timestamp': DateTime.now().toIso8601String(),
        'provider': 'cognito',
        'event_type': eventType,
      };
      
      // Emit the event
      await onEvent(eventType, enrichedData);
      
      print('Cognito event emitted: $eventType');
    } catch (e) {
      print('Failed to emit Cognito event: $e');
      throw DSAuthError('Failed to emit event: $e');
    }
  }
  
  /// Handles login success events
  Future<void> handleLoginSuccess(String userId, String email) async {
    await emitEvent('login_success', {
      'user_id': userId,
      'email': email,
      'authentication_method': 'password',
    });
  }
  
  /// Handles login failure events
  Future<void> handleLoginFailure(String email, String reason) async {
    await emitEvent('login_failure', {
      'email': email,
      'reason': reason,
      'authentication_method': 'password',
    });
  }
  
  /// Handles logout events
  Future<void> handleLogout(String userId) async {
    await emitEvent('logout', {
      'user_id': userId,
    });
  }
  
  /// Handles account creation events
  Future<void> handleAccountCreation(String userId, String email) async {
    await emitEvent('account_created', {
      'user_id': userId,
      'email': email,
    });
  }
  
  /// Handles password reset events
  Future<void> handlePasswordReset(String email) async {
    await emitEvent('password_reset_requested', {
      'email': email,
    });
  }
  
  /// Handles email confirmation events
  Future<void> handleEmailConfirmation(String email) async {
    await emitEvent('email_confirmed', {
      'email': email,
    });
  }
  
  /// Handles token refresh events
  Future<void> handleTokenRefresh(String userId) async {
    await emitEvent('token_refreshed', {
      'user_id': userId,
    });
  }
  
  /// Handles user attribute update events
  Future<void> handleAttributeUpdate(String userId, List<String> attributes) async {
    await emitEvent('attributes_updated', {
      'user_id': userId,
      'updated_attributes': attributes,
    });
  }
  
  /// Handles user deletion events
  Future<void> handleUserDeletion(String userId) async {
    await emitEvent('user_deleted', {
      'user_id': userId,
    });
  }
  
  /// Handles MFA events
  Future<void> handleMFAChallenge(String userId, String challengeType) async {
    await emitEvent('mfa_challenge', {
      'user_id': userId,
      'challenge_type': challengeType,
    });
  }
  
  /// Handles session events
  Future<void> handleSessionEvent(String userId, String action) async {
    await emitEvent('session_event', {
      'user_id': userId,
      'action': action,
    });
  }
  
  /// Handles error events
  Future<void> handleError(String operation, String error) async {
    await emitEvent('error', {
      'operation': operation,
      'error': error,
    });
  }
  
  /// Cleanup method
  void dispose() {
    _isInitialized = false;
    print('Cognito Event Handler disposed');
  }
}
