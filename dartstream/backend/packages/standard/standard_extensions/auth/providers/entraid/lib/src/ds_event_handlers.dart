import 'package:ds_auth_base/ds_auth_base_export.dart';



/// Handles Entra ID (Azure AD) authentication events
class DSEntraIDEventHandler {
  final Function(String, Map<String, dynamic>) onEvent;
  bool _isInitialized = false;

  DSEntraIDEventHandler({required this.onEvent});

  /// Initializes the event handler
  void initialize() {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;
    print('Entra ID Event Handler initialized');
  }

  /// Emits an authentication event
  Future<void> emitEvent(
    String eventType,
    Map<String, dynamic> eventData,
  ) async {
    if (!_isInitialized) {
      throw DSAuthError('Event handler not initialized');
    }

    try {
      final enrichedData = {
        ...eventData,
        'timestamp': DateTime.now().toIso8601String(),
        'provider': 'entraid',
        'event_type': eventType,
      };

      await onEvent(eventType, enrichedData);

      print('Entra ID event emitted: $eventType');
    } catch (e) {
      print('Failed to emit Entra ID event: $e');
      throw DSAuthError('Failed to emit event: $e');
    }
  }

  /* ============================
   * Authentication lifecycle
   * ============================ */

  /// Handles login success
  Future<void> handleLoginSuccess({
    required String userId,
    required String email,
    String authMethod = 'redirect', // redirect | popup | silent
  }) async {
    await emitEvent('login_success', {
      'user_id': userId,
      'email': email,
      'authentication_method': authMethod,
    });
  }

  /// Handles login failure
  Future<void> handleLoginFailure({
    required String email,
    required String reason,
  }) async {
    await emitEvent('login_failure', {
      'email': email,
      'reason': reason,
    });
  }

  /// Handles logout
  Future<void> handleLogout(String userId) async {
    await emitEvent('logout', {
      'user_id': userId,
    });
  }

  /* ============================
   * Account & identity events
   * ============================ */

  /// Handles user provisioning (enterprise onboarding)
  Future<void> handleAccountProvisioned({
    required String userId,
    required String email,
    String source = 'entra_id',
  }) async {
    await emitEvent('account_provisioned', {
      'user_id': userId,
      'email': email,
      'source': source,
    });
  }

  /// Handles account deletion / deprovisioning
  Future<void> handleAccountDeprovisioned(String userId) async {
    await emitEvent('account_deprovisioned', {
      'user_id': userId,
    });
  }

  /// Handles attribute updates (claims, roles, groups)
  Future<void> handleAttributeUpdate(
    String userId,
    List<String> attributes,
  ) async {
    await emitEvent('attributes_updated', {
      'user_id': userId,
      'updated_attributes': attributes,
    });
  }

  // Add user flow completion
Future<void> handleUserFlowComplete({
  required String flowName,
  required String userId,
  required String email,
}) async {
  await emitEvent('user_flow_complete', {
    'flow_name': flowName,
    'user_id': userId,
    'email': email,
  });
}

// Add password reset
Future<void> handlePasswordResetRequested({
  required String email,
}) async {
  await emitEvent('password_reset_requested', {
    'email': email,
  });
}

  /* ============================
   * Token & session events
   * ============================ */

  /// Handles access token refresh
  Future<void> handleTokenRefresh(String userId) async {
    await emitEvent('token_refreshed', {
      'user_id': userId,
      'grant_type': 'refresh_token',
    });
  }

  /// Handles silent auth / SSO
  Future<void> handleSilentAuth(String userId) async {
    await emitEvent('silent_auth', {
      'user_id': userId,
    });
  }

  /// Handles session lifecycle events
  Future<void> handleSessionEvent(
    String userId,
    String action, // started | extended | expired
  ) async {
    await emitEvent('session_event', {
      'user_id': userId,
      'action': action,
    });
  }

  /* ============================
   * MFA & security events
   * ============================ */

  /// Handles MFA challenge
  Future<void> handleMFAChallenge(
    String userId,
    String method, // sms | authenticator | fido2
  ) async {
    await emitEvent('mfa_challenge', {
      'user_id': userId,
      'challenge_type': method,
    });
  }

  /// Handles conditional access blocks
  Future<void> handleConditionalAccessFailure(
    String userId,
    String policy,
  ) async {
    await emitEvent('conditional_access_blocked', {
      'user_id': userId,
      'policy': policy,
    });
  }

  /* ============================
   * Error handling
   * ============================ */

  /// Handles generic error events
  Future<void> handleError({
    required String operation,
    required String error,
    String? aadErrorCode, // e.g. AADSTS50076
  }) async {
    await emitEvent('error', {
      'operation': operation,
      'error': error,
      if (aadErrorCode != null) 'aad_error_code': aadErrorCode,
    });
  }

  /// Cleanup
  void dispose() {
    _isInitialized = false;
    print('Entra ID Event Handler disposed');
  }
}
