// Import base authentication interfaces and types from DartStream core
import 'package:ds_auth_base/ds_auth_base_export.dart';
// Import Firebase SDK for authentication functionality
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

// Import local utility and handler implementations
import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';
import 'src/ds_event_handlers.dart';

/// Firebase authentication provider implementation for DartStream.
/// This class integrates Firebase Authentication with the DartStream framework
/// by implementing the DSAuthProvider interface.
///
/// Handles:
/// - User authentication via Firebase
/// - Token management
/// - Session tracking
/// - Event handling
/// - Error mapping
class DSFirebaseAuthProvider implements DSAuthProvider {
  /// Firebase project identifier
  final String projectId;

  /// Path to the Firebase private key file
  final String privateKeyPath;

  /// Firebase authentication instance
  late final FirebaseAuth _auth;

  /// Manages authentication tokens
  late final DSTokenManager _tokenManager;

  /// Manages user sessions
  late final DSSessionManager _sessionManager;

  /// Handles authentication events
  late final DSFirebaseEventHandler _eventHandler;

  /// Creates a new Firebase authentication provider
  DSFirebaseAuthProvider({
    required this.projectId,
    required this.privateKeyPath,
  }) {
    _initialize();
  }

  /// Initializes the Firebase authentication provider and its dependencies
  void _initialize() {
    // Initialize Firebase Auth with project configuration
    _auth = FirebaseAuth(
      projectId: projectId,
    );

    // Initialize token and session management
    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();

    // Set up event handling for auth state changes
    _eventHandler = DSFirebaseEventHandler(
      onEvent: _handleAuthEvent,
    );
    _eventHandler.initialize(_auth);
  }

  /// Signs in a user with username/email and password
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
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Signs out the current user and cleans up sessions
  @override
  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _tokenManager.removeToken(user.uid);
        await _sessionManager.removeSession(user.uid);
      }
      await _auth.signOut();
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Retrieves user information by user ID
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
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Verifies the validity of an authentication token
  @override
  Future<bool> verifyToken(String token) async {
    try {
      if (!_tokenManager.isTokenValid(token)) {
        return false;
      }

      final response =
          await _auth.performRequest('verifyIdToken', {'token': token});
      return response.statusCode == 200;
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Generates a unique device identifier for session management
  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Handles various authentication events from Firebase
  void _handleAuthEvent(DSAuthEvent event) {
    switch (event.type) {
      case DSAuthEventType.signedIn:
        // Handle successful sign in event
        break;
      case DSAuthEventType.signedOut:
        // Handle successful sign out event
        break;
      case DSAuthEventType.tokenRefreshed:
        // Handle token refresh event
        break;
      case DSAuthEventType.error:
        // Handle authentication error event
        break;
      default:
        // Handle any unrecognized events
        break;
    }
  }

  /// Cleans up resources used by the provider
  void dispose() {
    _auth.dispose();
  }
}
