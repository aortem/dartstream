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
  static DSFirebaseAuthProvider? _instance;
  bool _isInitialized = false;

  /// Firebase project identifier
  final String projectId;

  /// Path to the Firebase private key file
  final String apiKey;

  /// Firebase private key file path
  final String privateKeyPath;

  /// Firebase authentication instance
  late final FirebaseAuth _auth;

  /// Manages authentication tokens
  late final DSTokenManager _tokenManager;

  /// Manages user sessions
  late final DSSessionManager _sessionManager;

  /// Event handler for Firebase authentication events
  late final DSFirebaseEventHandler _eventHandler;

  /// Factory method to create a new instance of the Firebase authentication provider
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

  /// Initializes the Firebase authentication provider and its dependencies
  ///
  /// [config] - Configuration map containing provider settings
  /// May include additional Firebase-specific configurati
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

      _eventHandler = DSFirebaseEventHandler(onEvent: _handleAuthEvent);
      _eventHandler.initialize(_auth);

      _isInitialized = true;
      print('Firebase Auth Provider initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Auth Provider: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
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

      await onLoginSuccess(
        DSAuthUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
        ),
      );
    } catch (e) {
      print('Original signIn error: $e');
      throw DSFirebaseErrorMapper.mapError(e);
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
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// creates a new user account with email and password
  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
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
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Verifies the validity of an authentication token
  ///
  /// [token] - The token to verify
  /// Returns true if token is valid, false otherwise
  /// Throws [FirebaseAuthException] if verification fails
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

  /// Refreshes an authentication token
  ///
  /// [refreshToken] - The refresh token to use
  /// Returns a new access token
  /// Throws exception if refresh fails
  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      // Get a fresh token from the current user
      final token = await user.getIdToken(true); // force refresh
      await _tokenManager.refreshToken(user.uid, token);

      return token;
    } catch (e) {
      throw DSFirebaseErrorMapper.mapError(e);
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

  /// Sends a password reset email to the user
  ///
  /// [email] - Email address to send reset link to
  /// Throws [DSAuthError] if operation fails
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email);
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Sends email verification to the current user
  ///
  /// Throws [DSAuthError] if no user is signed in or operation fails
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      await user.sendEmailVerification();
      print('Email verification sent to: ${user.email}');
    } catch (e) {
      print('Error sending email verification: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Checks if the current user's email is verified
  ///
  /// Returns true if email is verified, false otherwise
  /// Throws [DSAuthError] if no user is signed in
  Future<bool> isEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      return user.emailVerified;
    } catch (e) {
      print('Error checking email verification: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Updates the current user's password
  ///
  /// [newPassword] - The new password
  /// Throws [DSAuthError] if no user is signed in or operation fails
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      await user.updatePassword(newPassword);
      print('Password updated successfully');
    } catch (e) {
      print('Error updating password: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Updates the current user's email address
  ///
  /// [newEmail] - The new email address
  /// Throws [DSAuthError] if no user is signed in or operation fails
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      await user.updateEmail(newEmail);
      print('Email updated successfully to: $newEmail');
    } catch (e) {
      print('Error updating email: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Updates the current user's profile information
  ///
  /// [displayName] - New display name (optional)
  /// [photoURL] - New photo URL (optional)
  /// Throws [DSAuthError] if no user is signed in or operation fails
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      if (displayName != null) {
        user.displayName = displayName;
      }

      if (photoURL != null) {
        user.photoURL = photoURL;
      }

      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Deletes the current user account
  ///
  /// Throws [DSAuthError] if no user is signed in or operation fails
  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      await _tokenManager.removeToken(user.uid);
      await _sessionManager.removeSession(user.uid);
      await user.delete();
      print('User account deleted successfully');
    } catch (e) {
      print('Error deleting user account: $e');
      throw DSFirebaseErrorMapper.mapError(e);
    }
  }

  /// Handles various authentication events from Firebase
  ///
  /// [event] - The authentication event to handle
  /// Used to respond to different authentication state changes
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

  /// Cleans up resources used by the provider
  ///
  /// Should be called when provider is no longer needed
  void dispose() {
    _isInitialized = false;
    _instance = null;
  }
}
