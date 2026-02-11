import 'package:crypto/crypto.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';

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
    _instance ??= DSMagicAuthProvider._internal(publishableKey: publishableKey, secretKey: secretKey);
    return _instance!;
  }

  DSMagicAuthProvider._internal({required this.publishableKey, required this.secretKey});

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
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
    final userInfo = await _verifyDIDTokenWithMagic(didToken);
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
    final userInfo = await _verifyDIDTokenWithMagic(_currentDIDToken!);
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
    return await _verifyDIDTokenWithMagic(didToken) != null;
  }

  Future<Map<String, dynamic>?> _verifyDIDTokenWithMagic(String didToken) async {
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
  Future<DSAuthUser> getUser(String userId) async => throw UnimplementedError();
  @override
  Future<String> refreshToken(String refreshToken) async => throw UnimplementedError();
}
