import 'dart:convert';

import 'package:ds_auth_base/ds_auth_provider.dart';

import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';
import 'src/ds_event_handlers.dart';

class DSCognitoAuthProvider implements DSAuthProvider {
  static DSCognitoAuthProvider? _instance;

  bool _isInitialized = false;

  final String userPoolId;
  final String clientId;
  final String region;
  final String? clientSecret;
  final String? identityPoolId;

  late final DSTokenManager _tokenManager;
  late final DSSessionManager _sessionManager;
  late final DSCognitoEventHandler _eventHandler;

  DSAuthUser? _currentUser;
  String? _accessToken;
  // ignore: unused_field
  String? _refreshToken;
  String? _idToken;

  factory DSCognitoAuthProvider({
    required String userPoolId,
    required String clientId,
    required String region,
    String? clientSecret,
    String? identityPoolId,
  }) {
    _instance ??= DSCognitoAuthProvider._internal(
      userPoolId: userPoolId,
      clientId: clientId,
      region: region,
      clientSecret: clientSecret,
      identityPoolId: identityPoolId,
    );
    return _instance!;
  }

  DSCognitoAuthProvider._internal({
    required this.userPoolId,
    required this.clientId,
    required this.region,
    this.clientSecret,
    this.identityPoolId,
  });

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw DSAuthError('Cognito Auth Provider not initialized');
    }
  }

  // ----------------------------------------------------------
  // DSAuthProvider IMPLEMENTATION
  // ----------------------------------------------------------

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) return;

    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();
    _eventHandler = DSCognitoEventHandler(onEvent: _handleAuthEvent);

    _eventHandler.initialize();
    _isInitialized = true;
  }

  @override
  Future<void> signIn(String username, String password) async {
    _ensureInitialized();

    try {
      final response = await _performCognitoSignIn(username, password);

      _accessToken = response['AccessToken'];
      _refreshToken = response['RefreshToken'];
      _idToken = response['IdToken'];

      _currentUser = await _createUserFromToken(_idToken!);
      await _sessionManager.storeSession(_currentUser!.id, _accessToken!);

      await onLoginSuccess(_currentUser!);
    } catch (e) {
      throw DSCognitoErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> signOut() async {
    _ensureInitialized();

    if (_currentUser != null) {
      await _sessionManager.clearSession(_currentUser!.id);
      await onLogout();
    }

    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    _idToken = null;
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    _ensureInitialized();

    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }

    return _currentUser!;
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    _ensureInitialized();

    if (_currentUser != null && _currentUser!.id == userId) {
      return _currentUser!;
    }

    throw DSAuthError('User not found');
  }

  @override
Future<bool> verifyToken([String? token]) async {
  _ensureInitialized();

  final tokenToVerify = token ?? _accessToken;
  if (tokenToVerify == null) return false;

  // Accept both Cognito mock access tokens and JWT id tokens
  if (tokenToVerify.startsWith('cognito_access_token_')) {
    return true;
  }

  // Fallback: verify JWT-like tokens (ID token)
  return _tokenManager.verifyToken(tokenToVerify);
}


@override
Future<String> refreshToken(String refreshToken) async {
  _ensureInitialized();

  _refreshToken = refreshToken;

  _accessToken =
      'cognito_access_token_${DateTime.now().millisecondsSinceEpoch}';

  return _accessToken!;
}


  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    _ensureInitialized();

    if (!email.contains('@')) {
      throw DSAuthError('Invalid email address');
    }

    if (password.length < 8) {
      throw DSAuthError('Password must be at least 8 characters');
    }

    await _eventHandler.handleAccountCreation('mock-user-id', email);
  }

  // ----------------------------------------------------------
  // INTERNAL HELPERS
  // ----------------------------------------------------------

  Future<Map<String, dynamic>> _performCognitoSignIn(
      String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!username.contains('@')) {
      throw DSAuthError('Invalid credentials');
    }

    return {
      'AccessToken': 'cognito_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'RefreshToken':
          'cognito_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'IdToken':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.'
              '${base64Url.encode('{"sub":"user-id","email":"$username","exp":9999999999}'.codeUnits)}.'
              'signature',
    };
  }

  Future<DSAuthUser> _createUserFromToken(String idToken) async {
    final claims = _tokenManager.decodeToken(idToken);

    return DSAuthUser(
      id: claims['sub'] ?? 'mock-user-id',
      email: claims['email'] ?? 'unknown@email.com',
      displayName: claims['email'] ?? 'Cognito User',
      customAttributes: claims,
    );
  }

  Future<void> _handleAuthEvent(
      String event, Map<String, dynamic> data) async {
    // no-op for now
  }

  @override
Future<void> onLoginSuccess(DSAuthUser user) async {
  await _eventHandler.handleLoginSuccess(
    user.id,
    user.email,
  );
}

@override
Future<void> onLogout() async {
  if (_currentUser != null) {
    await _eventHandler.handleLogout(_currentUser!.id);
  }
}

}
