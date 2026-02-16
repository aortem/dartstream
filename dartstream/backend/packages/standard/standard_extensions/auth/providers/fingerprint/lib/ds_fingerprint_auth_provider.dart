import 'package:ds_auth_base/ds_auth_base_export.dart';



class DSFingerprintAuthProvider implements DSAuthProvider {


  bool _initialized = false;

  DSFingerprintAuthProvider();

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    // ✅ DEV MODE SHORT-CIRCUIT
    if (config['__dev__'] == true) {
      print(
        'Fingerprint Auth Provider initialized in DEV mode (skipped apiKey)',
      );
      _initialized = true;
      return;
    }

    // 🔒 PROD MODE
    final apiKey = config['apiKey'];

    if (apiKey == null || apiKey is! String || apiKey.isEmpty) {
      throw DSAuthError('Fingerprint apiKey is required');
    }


    _initialized = true;

    print('Fingerprint Auth Provider initialized successfully');
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw DSAuthError(
        'Fingerprint Auth Provider not initialized. Call initialize() first.',
      );
    }
  }

  @override
  Future<void> signIn(String username, String password) async {
    _ensureInitialized();

    // DEV MODE → do nothing
    print('Fingerprint signIn skipped in DEV mode');
  }

  @override
  Future<void> signOut() async {
    _ensureInitialized();
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    _ensureInitialized();
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    _ensureInitialized();
    throw DSAuthError('Fingerprint does not support getCurrentUser');
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    _ensureInitialized();
    throw DSAuthError('Fingerprint does not support getUser');
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    _ensureInitialized();
    return true;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    _ensureInitialized();
    throw DSAuthError('Fingerprint does not support refreshToken');
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  @override
  Future<void> onLogout() async {}
}
