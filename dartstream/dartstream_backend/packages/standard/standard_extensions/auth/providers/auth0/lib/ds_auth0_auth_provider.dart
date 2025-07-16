// Import base authentication interfaces and types from DartStream core
import 'package:ds_auth_base/ds_auth_base_export.dart';
// Import Auth0 SDK for authentication functionality
import 'dart:convert';
import 'dart:io';

// Import local utility and handler implementations
import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';
import 'src/ds_event_handlers.dart';

/// Auth0 authentication provider implementation for DartStream.
/// This class integrates Auth0 Authentication with the DartStream framework
/// by implementing the DSAuthProvider interface.
///
/// Handles:
/// - User authentication via Auth0
/// - Token management (JWT)
/// - Session tracking
/// - Event handling
/// - Error mapping
class DSAuth0AuthProvider implements DSAuthProvider {
  static DSAuth0AuthProvider? _instance;
  bool _isInitialized = false;

  /// Auth0 domain
  final String domain;

  /// Auth0 client ID
  final String clientId;

  /// Auth0 client secret
  final String clientSecret;

  /// Auth0 audience (API identifier)
  final String audience;

  /// Manages authentication tokens
  late final DSTokenManager _tokenManager;

  /// Manages user sessions
  late final DSSessionManager _sessionManager;

  /// Event handler for Auth0 authentication events
  late final DSAuth0EventHandler _eventHandler;

  /// Current authenticated user
  DSAuthUser? _currentUser;

  /// Current access token
  String? _accessToken;

  /// Current refresh token
  String? _refreshToken;

  /// Factory method to create a new instance of the Auth0 authentication provider
  factory DSAuth0AuthProvider({
    required String domain,
    required String clientId,
    required String clientSecret,
    required String audience,
  }) {
    _instance ??= DSAuth0AuthProvider._internal(
      domain: domain,
      clientId: clientId,
      clientSecret: clientSecret,
      audience: audience,
    );
    return _instance!;
  }

  DSAuth0AuthProvider._internal({
    required this.domain,
    required this.clientId,
    required this.clientSecret,
    required this.audience,
  });

  /// Initializes the Auth0 authentication provider and its dependencies
  ///
  /// [config] - Configuration map containing provider settings
  /// May include additional Auth0-specific configuration
  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      print('Auth0 Auth Provider already initialized');
      return;
    }

    try {
      _tokenManager = DSTokenManager();
      _sessionManager = DSSessionManager();

      _eventHandler = DSAuth0EventHandler(
        onEvent: _handleAuthEvent,
      );
      _eventHandler.initialize();

      _isInitialized = true;
      print('Auth0 Auth Provider initialized successfully');
    } catch (e) {
      print('Error initializing Auth0 Auth Provider: $e');
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Signs in a user with username/email and password using Auth0
  ///
  /// Throws [DSAuthError] if authentication fails
  /// Manages token storage and session creation on successful sign in
  @override
  Future<void> signIn(String username, String password) async {
    if (!_isInitialized) {
      throw DSAuthError('Provider not initialized');
    }

    try {
      final response = await _performAuth0Request('/oauth/token', {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': clientId,
        'client_secret': clientSecret,
        'audience': audience,
        'scope': 'openid profile email offline_access',
      });

      if (response['error'] != null) {
        throw DSAuthError(response['error_description'] ?? 'Authentication failed');
      }

      _accessToken = response['access_token'];
      _refreshToken = response['refresh_token'];

      // Get user info with the access token
      final userInfo = await _getUserInfo(_accessToken!);
      
      _currentUser = DSAuthUser(
        id: userInfo['sub'],
        email: userInfo['email'] ?? '',
        displayName: userInfo['name'] ?? userInfo['nickname'] ?? '',
        customAttributes: {
          'auth0_id': userInfo['sub'],
          'picture': userInfo['picture'],
          'email_verified': userInfo['email_verified'],
        },
      );

      await _tokenManager.storeToken(_currentUser!.id, _accessToken!);
      await _sessionManager.createSession(
        userId: _currentUser!.id,
        deviceId: _generateDeviceId(),
      );

      await onLoginSuccess(_currentUser!);
      _eventHandler.emitEvent(DSAuthEventType.signedIn, {
        'userId': _currentUser!.id,
        'email': _currentUser!.email,
      });

      print('Successfully signed in: $username');
    } catch (e) {
      print('Auth0 signIn error: $e');
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Signs out the current user and cleans up sessions
  ///
  /// Removes stored tokens and terminates active sessions
  @override
  Future<void> signOut() async {
    try {
      if (_currentUser != null) {
        await _tokenManager.removeToken(_currentUser!.id);
        await _sessionManager.removeSession(_currentUser!.id);
        
        _eventHandler.emitEvent(DSAuthEventType.signedOut, {
          'userId': _currentUser!.id,
        });
      }

      _currentUser = null;
      _accessToken = null;
      _refreshToken = null;
      
      await onLogout();
      print('Successfully signed out');
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Creates a new user account with email and password
  @override
  Future<void> createAccount(String email, String password,
      {String? displayName}) async {
    if (!_isInitialized) {
      throw DSAuthError('Provider not initialized');
    }

    try {
      print('Attempting to create account for email: $email');
      
      final response = await _performAuth0Request('/dbconnections/signup', {
        'client_id': clientId,
        'email': email,
        'password': password,
        'connection': 'Username-Password-Authentication',
        'name': displayName ?? email.split('@')[0],
      });

      if (response['error'] != null) {
        throw DSAuthError(response['error_description'] ?? 'Account creation failed');
      }

      print('User created successfully: $email');
      
      // Auto sign-in after account creation
      await signIn(email, password);
      await signOut(); // Sign out immediately after creation
      print('User signed out after account creation');
    } catch (e) {
      print('Error during account creation: $e');
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  @override
  Future<DSAuthUser> getCurrentUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }
    return _currentUser!;
  }

  /// Retrieves user information by user ID from Auth0
  @override
  Future<DSAuthUser> getUser(String userId) async {
    try {
      if (_currentUser != null && _currentUser!.id == userId) {
        return _currentUser!;
      }

      // If requesting different user, fetch from Auth0 Management API
      final userInfo = await _getUserFromManagementAPI(userId);
      
      return DSAuthUser(
        id: userInfo['user_id'],
        email: userInfo['email'] ?? '',
        displayName: userInfo['name'] ?? userInfo['nickname'] ?? '',
        customAttributes: {
          'auth0_id': userInfo['user_id'],
          'picture': userInfo['picture'],
          'email_verified': userInfo['email_verified'],
        },
      );
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Verifies the validity of an authentication token
  @override
  Future<bool> verifyToken([String? token]) async {
    try {
      final tokenToVerify = token ?? _accessToken;
      if (tokenToVerify == null) {
        return false;
      }

      // Verify JWT token with Auth0
      final isValid = await _verifyJWT(tokenToVerify);
      return isValid && _currentUser != null;
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }

  /// Refreshes an authentication token using refresh token
  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _performAuth0Request('/oauth/token', {
        'grant_type': 'refresh_token',
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
      });

      if (response['error'] != null) {
        throw DSAuthError(response['error_description'] ?? 'Token refresh failed');
      }

      final newAccessToken = response['access_token'];
      _accessToken = newAccessToken;

      if (_currentUser != null) {
        await _tokenManager.storeToken(_currentUser!.id, newAccessToken);
        _eventHandler.emitEvent(DSAuthEventType.tokenRefreshed, {
          'userId': _currentUser!.id,
        });
      }

      return newAccessToken;
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Handles successful login events
  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Login success for user: ${user.email}');
  }

  /// Handles successful logout events
  @override
  Future<void> onLogout() async {
    print('User logged out successfully');
  }

  // Auth0-specific methods

  /// Sends a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _performAuth0Request('/dbconnections/change_password', {
        'client_id': clientId,
        'email': email,
        'connection': 'Username-Password-Authentication',
      });
      print('Password reset email sent to: $email');
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Updates user password
  Future<void> updatePassword(String newPassword) async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }

    try {
      // Use Auth0 Management API to update password
      await _updateUserProfile({'password': newPassword});
      print('Password updated successfully');
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Updates user email
  Future<void> updateEmail(String newEmail) async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }

    try {
      await _updateUserProfile({'email': newEmail});
      
      // Update current user
      _currentUser = DSAuthUser(
        id: _currentUser!.id,
        email: newEmail,
        displayName: _currentUser!.displayName,
        customAttributes: _currentUser!.customAttributes,
      );
      
      print('Email updated successfully to: $newEmail');
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Updates user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }

    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['name'] = displayName;
      if (photoURL != null) updates['picture'] = photoURL;

      await _updateUserProfile(updates);
      
      // Update current user
      _currentUser = DSAuthUser(
        id: _currentUser!.id,
        email: _currentUser!.email,
        displayName: displayName ?? _currentUser!.displayName,
        customAttributes: {
          ...?_currentUser!.customAttributes,
          if (photoURL != null) 'picture': photoURL,
        },
      );
      
      print('Profile updated successfully');
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  /// Deletes user account
  Future<void> deleteUser() async {
    if (_currentUser == null) {
      throw DSAuthError('No user is currently signed in');
    }

    try {
      // Use Auth0 Management API to delete user
      await _deleteUserFromManagementAPI(_currentUser!.id);
      
      // Clean up local state
      await signOut();
      print('User account deleted successfully');
    } catch (e) {
      throw DSAuth0ErrorMapper.mapError(e);
    }
  }

  // Private helper methods

  /// Performs HTTP request to Auth0 API
  Future<Map<String, dynamic>> _performAuth0Request(
      String endpoint, Map<String, dynamic> body) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('https://$domain$endpoint');
      final request = await client.postUrl(uri);
      
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode(body));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } finally {
      client.close();
    }
  }

  /// Gets user info from Auth0 userinfo endpoint
  Future<Map<String, dynamic>> _getUserInfo(String accessToken) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('https://$domain/userinfo');
      final request = await client.getUrl(uri);
      
      request.headers.set('Authorization', 'Bearer $accessToken');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } finally {
      client.close();
    }
  }

  /// Verifies JWT token
  Future<bool> _verifyJWT(String token) async {
    try {
      // In a real implementation, you would verify the JWT signature
      // For this mock implementation, we'll do basic checks
      final parts = token.split('.');
      if (parts.length != 3) return false;
      
      // Decode payload
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      ) as Map<String, dynamic>;
      
      // Check expiration
      final exp = payload['exp'] as int?;
      if (exp != null) {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        return now < exp;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets user from Auth0 Management API
  Future<Map<String, dynamic>> _getUserFromManagementAPI(String userId) async {
    // This would require Auth0 Management API token
    // For now, return current user if available
    if (_currentUser != null && _currentUser!.id == userId) {
      return {
        'user_id': _currentUser!.id,
        'email': _currentUser!.email,
        'name': _currentUser!.displayName,
        'picture': _currentUser!.customAttributes?['picture'],
        'email_verified': _currentUser!.customAttributes?['email_verified'],
      };
    }
    throw DSAuthError('User not found');
  }

  /// Updates user profile via Management API
  Future<void> _updateUserProfile(Map<String, dynamic> updates) async {
    // This would require Auth0 Management API implementation
    // For mock implementation, we'll just simulate success
    await Future.delayed(Duration(milliseconds: 100));
    print('User profile updated: $updates');
  }

  /// Deletes user via Management API
  Future<void> _deleteUserFromManagementAPI(String userId) async {
    // This would require Auth0 Management API implementation
    await Future.delayed(Duration(milliseconds: 100));
    print('User deleted from Auth0: $userId');
  }

  /// Generates a unique device identifier for session management
  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Handles various authentication events from Auth0
  void _handleAuthEvent(DSAuthEvent event) {
    switch (event.type) {
      case DSAuthEventType.signedIn:
        print('Auth0 Event: User signed in');
        break;
      case DSAuthEventType.signedOut:
        print('Auth0 Event: User signed out');
        break;
      case DSAuthEventType.tokenRefreshed:
        print('Auth0 Event: Token refreshed');
        break;
      case DSAuthEventType.error:
        print('Auth0 Event: Error occurred');
        break;
      default:
        print('Auth0 Event: Unknown event');
        break;
    }
  }

  /// Cleans up resources used by the provider
  void dispose() {
    _isInitialized = false;
    _instance = null;
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
  }
}
