import 'package:ds_auth_base/ds_auth_base_export.dart';
// import 'src/ds_error_mapper.dart'; // ⚠️ Removed, unused

import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_event_handlers.dart';

/// MOCK Stytch authentication provider
/// ⚠️ Open-source safe
class DSStytchAuthProvider implements DSAuthProvider {
  bool _initialized = false;

  final Map<String, _MockUser> _usersByEmail = {};
  _MockUser? _currentUser;

  late final DSTokenManager _tokenManager;
  late final DSSessionManager _sessionManager;

  // late final DSStytchEventHandler _eventHandler; // ⚠️ Removed, unused

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) return;

    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();

    _initialized = true;
  }

  void _ensureInit() {
    if (!_initialized) {
      throw DSAuthError('Stytch provider not initialized');
    }
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    _ensureInit();

    if (_usersByEmail.containsKey(email)) {
      throw DSAuthError('User already exists');
    }

    _usersByEmail[email] = _MockUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      password: password,
      displayName: displayName ?? email.split('@').first,
    );
  }

  @override
  Future<void> signIn(String username, String password) async {
    _ensureInit();

    final user = _usersByEmail[username];
    if (user == null || user.password != password) {
      throw DSAuthError('Invalid credentials');
    }

    _currentUser = user;

    _tokenManager.issueToken(user.id); // ⚠️ token value not needed
    _sessionManager.startSession(user.id);

    await onLoginSuccess(_toDSUser(user));
  }

  @override
  Future<void> signOut() async {
    _ensureInit();

    if (_currentUser != null) {
      _tokenManager.revokeTokens(_currentUser!.id);
      _sessionManager.endSession(_currentUser!.id);
    }

    _currentUser = null;
    await onLogout();
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    _ensureInit();

    if (_currentUser == null) {
      throw DSAuthError('No active user');
    }

    return _toDSUser(_currentUser!);
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    _ensureInit();

    return _toDSUser(
      _usersByEmail.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw DSAuthError('User not found'),
      ),
    );
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    _ensureInit();
    if (token == null) return false;
    return _tokenManager.verify(token);
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    _ensureInit();

    if (!_tokenManager.verify(refreshToken)) {
      throw DSAuthError('Invalid token');
    }

    return refreshToken; // mock behavior
  }

  /// -------------------------
  /// IMPLEMENT ABSTRACT HOOKS
  /// -------------------------

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // nothing to do in mock
  }

  @override
  Future<void> onLogout() async {
    // nothing to do in mock
  }

  DSAuthUser _toDSUser(_MockUser user) {
    return DSAuthUser(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
    );
  }
}

/// Private mock user class
class _MockUser {
  final String id;
  final String email;
  final String password;
  final String displayName;

  _MockUser({
    required this.id,
    required this.email,
    required this.password,
    required this.displayName,
  });
}
