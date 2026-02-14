// ignore_for_file: unused_field, unused_local_variable, unused_element, deprecated_member_use
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';

class DSMagicAuthProvider implements DSAuthProvider {
  static DSMagicAuthProvider? _instance;
  bool _isInitialized = false;

  final String publishableKey;
  final String secretKey;

  late final DSTokenManager _tokenManager;
  late final DSSessionManager _sessionManager;

  String? _currentUserId;
  String? _currentDIDToken;

  factory DSMagicAuthProvider({required this.publishableKey, required this.secretKey}) {
    _instance ??= DSMagicAuthProvider.internal(publishableKey: publishableKey, secretKey: secretKey);
    return _instance!;
  }

  DSMagicAuthProvider.internal({required this.publishableKey, required this.secretKey});

  static void resetInstance() {
    _instance = null;
  }

  @override
  Future<void> initialize(Map<String, dynamic> _config) async {
    if (_isInitialized) return;
    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();
    _isInitialized = true;
    print('Magic Auth Provider initialized');
  }

  void _ensureInitialized() {
    if (!_isInitialized) throw DSAuthError('Magic Auth Provider not initialized', code: 500);
  }

  @override
  Future<void> signIn(String email, String password) async {
    _ensureInitialized();
    final didToken = password;
    if (didToken.isEmpty) throw DSAuthError('DID token required');
    final userInfo = await verifyDIDTokenWithMagic(didToken);
    if (userInfo == null) throw DSAuthError('Failed to verify DID token');
    _currentUserId = userInfo['issuer'];
    _currentDIDToken = didToken;

    await _tokenManager.storeToken(_currentUserId!, didToken);
    await _sessionManager.createSession(userId: _currentUserId!, deviceId: _generateDeviceId());

    await onLoginSuccess(DSAuthUser(
      id: userInfo['issuer'],
      email: userInfo['email'] ?? '',
      displayName: userInfo['publicAddress'] ?? '',
      customAttributes: userInfo,
    ));
  }

  @override
  Future<void> signOut() async {
    _ensureInitialized();
    if (_currentUserId != null) {
      await _tokenManager.removeToken(_currentUserId!);
      await _sessionManager.removeSession(_currentUserId!);
    }
    _currentUserId = null;
    _currentDIDToken = null;
    await onLogout();
  }

  @override
  Future<void> createAccount(String email, String password, {String? displayName}) async {
    await signIn(email, password);
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    _ensureInitialized();
    if (_currentUserId == null || _currentDIDToken == null) throw DSAuthError('No signed-in user');
    final userInfo = await verifyDIDTokenWithMagic(_currentDIDToken!);
    // Safety check just in case verify returns null unexpectedly for stored token
    if (userInfo == null) throw DSAuthError('Session invalid');
    
    return DSAuthUser(
      id: userInfo['issuer'],
      email: userInfo['email'] ?? '',
      displayName: userInfo['publicAddress'] ?? '',
      customAttributes: userInfo,
    );
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    _ensureInitialized();
    final didToken = token ?? _currentDIDToken;
    if (didToken == null) return false;
    return await verifyDIDTokenWithMagic(didToken) != null;
  }

  /// Verifies the DID token. Exposed for testing override.
  Future<Map<String, dynamic>?> verifyDIDTokenWithMagic(String didToken) async {
    try {
      final payload = MagicTokenDecoder.decode(didToken, verify: true);
      return {'issuer': payload['iss'], 'email': payload['email'], 'publicAddress': payload['publicAddress']};
    } catch (e) {
      print('Failed to verify DID token: $e');
      return null;
    }
  }

  String _generateDeviceId() => 'device_${DateTime.now().millisecondsSinceEpoch}';

  void clearCurrentSession() {
    _currentUserId = null;
    _currentDIDToken = null;
  }

  String? get currentUserId => _currentUserId;
  String? get currentDIDToken => _currentDIDToken;
  bool get isSignedIn => _currentUserId != null && _currentDIDToken != null;

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}
  @override
  Future<void> onLogout() async {}
  
  @override
  Future<DSAuthUser> getUser(String userId) async {
    _ensureInitialized();
    if (_currentUserId == userId) {
      return getCurrentUser();
    }
    throw DSAuthError('User not found', code: 404);
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    _ensureInitialized();
    // Magic links don't have traditional refresh tokens in this flow,
    // so we validate the existing token.
    if (await verifyToken(refreshToken)) {
      return refreshToken;
    }
    throw DSAuthError('Invalid token', code: 401);
  }
}
