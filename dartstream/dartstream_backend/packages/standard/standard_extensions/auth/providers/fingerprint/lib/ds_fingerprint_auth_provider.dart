import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:fingerprint_dart_auth_sdk/fingerprint_dart_auth_sdk.dart';

import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';

class DSFingerprintAuthProvider implements DSAuthProvider {
  static DSFingerprintAuthProvider? _instance;

  late final AortemFingerprintAuth _auth;
  late final DSTokenManager _tokenManager;
  late final DSSessionManager _sessionManager;

  bool _isInitialized = false;

  String? _currentUserId;
  String? _currentFingerprintPayload;

  factory DSFingerprintAuthProvider({required String apiKey}) {
    _instance ??= DSFingerprintAuthProvider._internal(apiKey);
    return _instance!;
  }

  DSFingerprintAuthProvider._internal(String apiKey) {
    _auth = AortemFingerprintAuth(apiKey: apiKey);
  }

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();
    _isInitialized = true;
    print('Fingerprint Auth Provider initialized');
  }

  @override
  Future<void> signIn(String email, String password) async {
    // password = fingerprint payload as JSON
    try {
      if (password.isEmpty) {
        throw DSAuthError('Fingerprint payload required for sign-in');
      }

      final verificationResult = await _auth.verify(password);

      final visitorId = verificationResult['visitorId'];
      if (visitorId == null || visitorId.toString().isEmpty) {
        throw DSAuthError('Invalid fingerprint payload');
      }

      _currentUserId = visitorId;
      _currentFingerprintPayload = password;

      await _tokenManager.storeToken(visitorId, password);
      await _sessionManager.createSession(
        userId: visitorId,
        deviceId: _generateDeviceId(),
      );

      await onLoginSuccess(
        DSAuthUser(
          id: visitorId,
          email: email,
          displayName: verificationResult['ip'] ?? '',
          customAttributes: verificationResult,
        ),
      );
    } catch (e) {
      throw DSMagicErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (_currentUserId != null) {
        await _tokenManager.removeToken(_currentUserId!);
        await _sessionManager.removeSession(_currentUserId!);
      }
      _currentUserId = null;
      _currentFingerprintPayload = null;
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
    if (_currentUserId == null || _currentFingerprintPayload == null) {
      throw DSAuthError('No user is currently signed in');
    }

    final verificationResult = await _auth.verify(_currentFingerprintPayload!);
    return DSAuthUser(
      id: verificationResult['visitorId'],
      email: '',
      displayName: verificationResult['ip'] ?? '',
      customAttributes: verificationResult,
    );
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    throw UnimplementedError(
      'getUser not supported by fingerprint verification provider.',
    );
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    final payload = token ?? _currentFingerprintPayload;
    if (payload == null) return false;
    try {
      final result = await _auth.verify(payload);
      return result.containsKey('visitorId');
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    throw UnimplementedError(
      'Fingerprint tokens are not refreshable. Re-authenticate.',
    );
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Fingerprint login success for ${user.id}');
  }

  @override
  Future<void> onLogout() async {
    print('Fingerprint logout');
  }

  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
