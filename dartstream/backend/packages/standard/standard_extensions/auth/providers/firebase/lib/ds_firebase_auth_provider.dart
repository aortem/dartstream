// Import base authentication interfaces and types from DartStream core
import 'package:ds_auth_base/ds_auth_base_export.dart';

// Firebase Admin SDK
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

// Local utils
import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_event_handlers.dart';

/// Dev mode flag
const bool kIsDev = true;

/// Firebase authentication provider
class DSFirebaseAuthProvider implements DSAuthProvider {
  static DSFirebaseAuthProvider? _instance;
  bool _isInitialized = false;

  final String projectId;
  final String apiKey;
  final String privateKeyPath;

  late final FirebaseAuth _auth;
  late final DSTokenManager _tokenManager;
  late final DSSessionManager _sessionManager;
  late final DSFirebaseEventHandler _eventHandler;

  factory DSFirebaseAuthProvider({
    required String projectId,
    required String privateKeyPath,
    required String apiKey,
  }) {
    _instance ??= DSFirebaseAuthProvider._internal(
      projectId: projectId,
      privateKeyPath: privateKeyPath,
      apiKey: apiKey,
    );
    return _instance!;
  }

  DSFirebaseAuthProvider._internal({
    required this.projectId,
    required this.privateKeyPath,
    required this.apiKey,
  });

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) return;

    _auth = FirebaseApp.instance.getAuth();
    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();

    _eventHandler = DSFirebaseEventHandler(onEvent: _handleAuthEvent);
    _eventHandler.initialize(_auth);

    _isInitialized = true;
  }

  @override
  Future<void> signIn(String username, String password) async {
    final credential =
        await _auth.signInWithEmailAndPassword(username, password);

    final user = credential!.user;
    final token = await user.getIdToken();

    await _tokenManager.storeToken(user.uid, token);
    await _sessionManager.createSession(
      userId: user.uid,
      deviceId: 'mock-device-id',
    );

    await onLoginSuccess(
      DSAuthUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      ),
    );
  }

  @override
  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _tokenManager.removeToken(user.uid);
      await _sessionManager.removeSession(user.uid);
    }
    if (!kIsDev) await _auth.signOut();
    await onLogout();
  }

  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(email, password);

    credential.user; // ensure non-null
    if (!kIsDev) await signOut();
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No signed-in user');

    return DSAuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    return _auth.currentUser != null;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final user = _auth.currentUser!;
    final token = await user.getIdToken(true);

    await _tokenManager.refreshToken(user.uid, token);
    return token;
  }

  // ===== Dev-safe Firebase methods =====

  Future<void> sendEmailVerification() async {
    // Not supported by Admin SDK
    return;
  }

  Future<bool> isEmailVerified() async {
    if (kIsDev) return true;
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  Future<void> updatePassword(String newPassword) async {
    // Not supported by Admin SDK
    return;
  }

  Future<void> updateEmail(String newEmail) async {
    // Not supported by Admin SDK
    return;
  }

  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _tokenManager.removeToken(user.uid);
    await _sessionManager.removeSession(user.uid);
    // No delete API available in this SDK
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    if (kIsDev) {
      return DSAuthUser(
        id: userId,
        email: 'devuser@example.com',
        displayName: 'Dev User',
      );
    }

    final user = _auth.currentUser;
    if (user == null) throw Exception('User not found');

    return DSAuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  @override
  Future<void> onLogout() async {}

  void _handleAuthEvent(DSAuthEvent event) {}
}
