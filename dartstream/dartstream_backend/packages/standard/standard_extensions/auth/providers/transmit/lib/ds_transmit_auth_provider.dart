import 'src/ds_error_mapper.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_token_manager.dart';
import 'src/ds_event_handlers.dart';

class DSTransmitAuthProvider {
  final DSTransmitErrorMapper _errorMapper = DSTransmitErrorMapper();
  final DSTransmitSessionManager _sessionManager = DSTransmitSessionManager();
  final DSTransmitTokenManager _tokenManager = DSTransmitTokenManager();
  final DSTransmitEventHandlers _eventHandlers = DSTransmitEventHandlers();

  Future<void> initialize(Map<String, dynamic> config) async {
    // Initialize transmit-specific keys/configs here
  }

  Future<void> signIn(String token) async {
    // Validate token with Transmit's API
    _tokenManager.saveToken(token);
    _sessionManager.createSession(token);
    _eventHandlers.onLoginSuccess();
  }

  void signOut() {
    _tokenManager.clearToken();
    _sessionManager.endSession();
    _eventHandlers.onLogout();
  }

  // Other core authentication methods as required
}
