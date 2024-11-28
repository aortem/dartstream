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
  /// Provider metadata for registration and management
  static final Map<String, dynamic> _providerMetadata = {
    'type': 'firebase',
    'region': 'global',
    'clientId': null,
  };

  /// Returns the provider's metadata
  static Map<String, dynamic> getMetadata() => _providerMetadata;

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
  });

  /// Initializes the Firebase authentication provider and its dependencies
  ///
  /// [config] - Configuration map containing provider settings
  /// May include additional Firebase-specific configurations
  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    // Update metadata
    _providerMetadata['clientId'] = config['projectId'] ?? projectId;

    _auth = FirebaseAuth(
      projectId: config['projectId'] ?? projectId,
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
  ///
  /// Throws [FirebaseAuthException] if authentication fails
  /// Manages token storage and session creation on successful sign in
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
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Signs out the current user and cleans up sessions
  ///
  /// Removes stored tokens and terminates active sessions
  /// Throws [FirebaseAuthException] if sign out fails
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
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Handles successful login events
  ///
  /// [user] - The authenticated user information
  /// Can be used to perform additional post-login actions
  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // Handle successful login
  }

  /// Handles successful logout events
  ///
  /// Can be used to perform additional cleanup or post-logout actions
  @override
  Future<void> onLogout() async {
    // Handle successful logout
  }

  /// Retrieves user information by user ID
  ///
  /// [userId] - The unique identifier of the user
  /// Returns [DSAuthUser] containing user information
  /// Throws exception if user is not found
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
  ///
  /// [token] - The token to verify
  /// Returns true if token is valid, false otherwise
  /// Throws [FirebaseAuthException] if verification fails
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

  /// Refreshes an authentication token
  ///
  /// [token] - The refresh token to use
  /// Returns a new access token
  /// Throws exception if refresh fails
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
      throw DSFirebaseErrorMapper.mapError(e as FirebaseAuthException);
    }
  }

  /// Generates a unique device identifier for session management
  ///
  /// Returns a timestamp-based unique identifier
  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Handles various authentication events from Firebase
  ///
  /// [event] - The authentication event to handle
  /// Used to respond to different authentication state changes
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
  ///
  /// Should be called when provider is no longer needed
  void dispose() {
    _auth.dispose();
  }
}
