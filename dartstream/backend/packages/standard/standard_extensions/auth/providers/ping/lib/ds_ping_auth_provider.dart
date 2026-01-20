import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'src/ds_session_manager.dart';
import 'src/ds_token_manager.dart';


class DSPingAuthProvider extends DSAuthProvider {
  final _sessionManager = DSPingSessionManager();
  final _tokenManager = DSPingTokenManager();

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    // mock no-op
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    if (_sessionManager.userExists(email)) {
      throw DSAuthError('User already exists');
    }

    _sessionManager.createUser(
      email: email,
      password: password,
      displayName: displayName ?? email.split('@').first,
    );
  }

  @override
  Future<void> signIn(String username, String password) async {
    final user = _sessionManager.authenticate(username, password);
    _tokenManager.issueTokens(user.id);
    await onLoginSuccess(user);
  }

  @override
  Future<void> signOut() async {
    _sessionManager.clearSession();
    _tokenManager.clearTokens();
    await onLogout();
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    final user = _sessionManager.currentUser;
    if (user == null) {
      throw DSAuthError('No user signed in');
    }
    return user;
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    final user = _sessionManager.getUserById(userId);
    if (user == null) {
      throw DSAuthError('User not found');
    }
    return user;
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    return _tokenManager.verify(token);
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    return _tokenManager.refresh(refreshToken);
  }

  // ✅ REQUIRED lifecycle hooks
  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  @override
  Future<void> onLogout() async {}
}
