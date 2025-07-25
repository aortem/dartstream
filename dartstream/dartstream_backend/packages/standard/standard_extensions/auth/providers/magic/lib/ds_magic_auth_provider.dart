// Import base authentication interfaces and types from DartStream core
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
  late final AortemMagicAuth _auth;

  String? _currentUserId;
  String? _currentDIDToken;

  factory DSMagicAuthProvider({
    required String publishableKey,
    required String secretKey,
  }) {
    _instance ??= DSMagicAuthProvider._internal(
      publishableKey: publishableKey,
      secretKey: secretKey,
    );
    return _instance!;
  }

  DSMagicAuthProvider._internal({
    required this.publishableKey,
    required this.secretKey,
  });

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      print('Magic Auth Provider already initialized');
      return;
    }

    _auth = AortemMagicAuth(secretKey);
    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();
    _isInitialized = true;
    print('Magic Auth Provider initialized successfully');
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      final didToken = password;
      if (didToken.isEmpty) {
        throw DSAuthError('DID token is required for Magic sign-in');
      }

      final userInfo = await _verifyDIDTokenWithMagic(didToken);
      if (userInfo == null) {
        throw DSAuthError('Failed to verify Magic DID token');
      }

      _currentUserId = userInfo['issuer'];
      _currentDIDToken = didToken;

      await _tokenManager.storeToken(_currentUserId!, didToken);
      await _sessionManager.createSession(
        userId: _currentUserId!,
        deviceId: _generateDeviceId(),
      );

      await onLoginSuccess(
        DSAuthUser(
          id: userInfo['issuer'],
          email: userInfo['email'] ?? '',
          displayName: userInfo['publicAddress'] ?? '',
          customAttributes: userInfo,
        ),
      );
    } catch (e) {
      throw DSMagicErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (_currentDIDToken != null) {
        await AortemMagicLogoutByToken(
          apiKey: secretKey,
          useStub: false,
        ).logoutByToken(_currentDIDToken!);
      }

      if (_currentUserId != null) {
        await _tokenManager.removeToken(_currentUserId!);
        await _sessionManager.removeSession(_currentUserId!);
      }

      _currentUserId = null;
      _currentDIDToken = null;
      await onLogout();
    } catch (e) {
      throw DSMagicErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    await signIn(email, password);
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUserId == null || _currentDIDToken == null) {
      throw DSAuthError('No user is currently signed in');
    }

    final userInfo = await _verifyDIDTokenWithMagic(_currentDIDToken!);
    if (userInfo == null) {
      throw DSAuthError('Failed to fetch user info');
    }

    return DSAuthUser(
      id: userInfo['issuer'],
      email: userInfo['email'] ?? '',
      displayName: userInfo['publicAddress'] ?? '',
      customAttributes: userInfo,
    );
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    throw UnimplementedError(
      'getUser is not supported by Magic API. Store user info after sign-in.',
    );
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    final didToken = token ?? _currentDIDToken;
    if (didToken == null) return false;

    final userInfo = await _verifyDIDTokenWithMagic(didToken);
    return userInfo != null;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    throw UnimplementedError(
      'Magic tokens cannot be refreshed; re-authenticate instead.',
    );
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // Optionally handle post-login logic
  }

  @override
  Future<void> onLogout() async {
    // Optionally handle post-logout logic
  }

  Future<Map<String, dynamic>?> _verifyDIDTokenWithMagic(
    String didToken,
  ) async {
    try {
      final payload = AortemMagicTokenDecoder.decode(didToken, verify: true);
      return {
        'issuer': payload['iss'],
        'email': payload['email'],
        'publicAddress': payload['publicAddress'],
      };
    } catch (e) {
      return null;
    }
  }

  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
