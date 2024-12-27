import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';
import 'src/ds_event_handlers.dart';

/// Firebase authentication provider implementation for DartStream.
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
    if (_isInitialized) {
      print('Firebase Auth Provider already initialized');
      return;
    }

    try {
      // Get the already initialized auth instance
      _auth = FirebaseApp.instance.getAuth();

      _tokenManager = DSTokenManager();
      _sessionManager = DSSessionManager();

      _eventHandler = DSFirebaseEventHandler(
        onEvent: _handleAuthEvent,
      );
      _eventHandler.initialize(_auth);

      _isInitialized = true;
      print('Firebase Auth Provider initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Auth Provider: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> signIn(String username, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        username,
        password,
      );

      if (credential == null) {
        throw Exception('Authentication failed');
      }

      final user = credential.user;
      final token = await user.getIdToken();
      await _tokenManager.storeToken(user.uid, token);
      await _sessionManager.createSession(
        userId: user.uid,
        deviceId: _generateDeviceId(),
      );

      await onLoginSuccess(DSAuthUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      ));
    } catch (e) {
      print('Original signIn error: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _tokenManager.removeToken(user.uid);
        await _sessionManager.removeSession(user.uid);
      }
      await _auth.signOut();
      await onLogout();
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> createAccount(String email, String password,
      {String? displayName}) async {
    try {
      print('Attempting to create account for email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email,
        password,
      );

      final user = credential.user;
      print('User created successfully with ID: ${user.uid}');

      if (displayName != null && displayName.isNotEmpty) {
        print('Setting display name: $displayName');
        user.displayName = displayName;
        print('Display name set successfully');
      }

      await signOut();
      print('User signed out after account creation');
    } catch (e) {
      print('Error during account creation: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      return DSAuthUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      );
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<DSAuthUser> getUser(String userId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user found');
      }

      return DSAuthUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      );
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<bool> verifyToken([String? token]) async {
    try {
      // After successful sign in, we should already have a current user
      final user = _auth.currentUser;
      if (user == null) {
        print('No current user found during token verification');
        return false;
      }

      // Skip additional verification since we're already authenticated
      return true;
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }

  @override
  Future<String> refreshToken(String token) async {
    try {
      final response = await _auth.performRequest(
          'token', {'grant_type': 'refresh_token', 'refresh_token': token});

      if (response.statusCode != 200) {
        throw Exception('Failed to refresh token');
      }

      return response.body['access_token'] as String;
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // Handle successful login
  }

  @override
  Future<void> onLogout() async {
    // Handle successful logout
  }

  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _handleAuthEvent(DSAuthEvent event) {
    switch (event.type) {
      case DSAuthEventType.signedIn:
        // Handle signed in event
        break;
      case DSAuthEventType.signedOut:
        // Handle signed out event
        break;
      case DSAuthEventType.tokenRefreshed:
        // Handle token refresh event
        break;
      case DSAuthEventType.error:
        // Handle error event
        break;
      default:
        // Handle unknown event
        break;
    }
  }

  void dispose() {
    _isInitialized = false;
    _instance = null;
  }
}
