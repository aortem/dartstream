import 'package:ds_auth_base/ds_auth_provider.dart';

class DSCognitoEventHandler {
  final Future<void> Function(String, Map<String, dynamic>) onEvent;
  bool _isInitialized = false;

  DSCognitoEventHandler({required this.onEvent});

  void initialize() {
    _isInitialized = true;
  }

  Future<void> emitEvent(
    String eventType,
    Map<String, dynamic> eventData,
  ) async {
    if (!_isInitialized) {
      throw DSAuthError('Event handler not initialized');
    }

    final enrichedData = {
      ...eventData,
      'timestamp': DateTime.now().toIso8601String(),
      'provider': 'cognito',
      'event_type': eventType,
    };

    await onEvent(eventType, enrichedData);
  }

  // -------------------------
  // REQUIRED EVENT METHODS
  // -------------------------

  Future<void> handleLoginSuccess(String userId, String email) async {
    await emitEvent('login_success', {'user_id': userId, 'email': email});
  }

  Future<void> handleLogout(String userId) async {
    await emitEvent('logout', {'user_id': userId});
  }

  Future<void> handleAccountCreation(String userId, String email) async {
    await emitEvent('account_created', {'user_id': userId, 'email': email});
  }
}
