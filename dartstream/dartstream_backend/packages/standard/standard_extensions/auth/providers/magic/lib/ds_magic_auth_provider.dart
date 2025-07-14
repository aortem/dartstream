// Import base authentication interfaces and types from DartStream core
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// TODO: If Magic releases a Dart SDK, import it here

// Import local utility and handler implementations
import 'src/ds_token_manager.dart';
import 'src/ds_session_manager.dart';
import 'src/ds_error_mapper.dart';
// import 'src/ds_event_handlers.dart'; // Uncomment if Magic supports events

/// Magic authentication provider implementation for DartStream.
///
/// This class integrates Magic Authentication with the DartStream framework
/// by implementing the DSAuthProvider interface.
///
/// Handles:
/// - User authentication via Magic
/// - Token management (DID tokens)
/// - Session tracking
/// - Error mapping
class DSMagicAuthProvider implements DSAuthProvider {
  /// Singleton instance
  static DSMagicAuthProvider? _instance;

  /// Whether the provider is initialized
  bool _isInitialized = false;

  /// Magic publishable key
  final String publishableKey;

  /// Magic secret key
  final String secretKey;

  late final DSTokenManager _tokenManager;
  late final DSSessionManager _sessionManager;
  // late final DSMagicEventHandler _eventHandler; // Uncomment if needed

  /// Current authenticated user ID
  String? _currentUserId;

  /// Current DID token
  String? _currentDIDToken;

  /// Factory method to create a new instance of the Magic authentication provider
  ///
  /// [publishableKey] - Magic publishable key
  /// [secretKey] - Magic secret key
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

  /// Initializes the Magic authentication provider and its dependencies
  ///
  /// [config] - Configuration map containing provider settings
  /// Throws [DSAuthError] if initialization fails
  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      print('Magic Auth Provider already initialized');
      return;
    }
    // Optionally, validate keys or set up Magic REST endpoints
    _tokenManager = DSTokenManager();
    _sessionManager = DSSessionManager();
    // _eventHandler = DSMagicEventHandler(onEvent: _handleAuthEvent); // Uncomment if needed
    _isInitialized = true;
    print('Magic Auth Provider initialized successfully');
  }

  /// Signs in a user with email (Magic is passwordless)
  ///
  /// [email] - User's email address
  /// [password] - Magic DID token (from frontend)
  /// Throws [DSAuthError] if sign-in fails
  @override
  Future<void> signIn(String email, String password) async {
    // Magic is passwordless; password param is ignored except as DID token
    try {
      // 1. Trigger Magic link (handled on frontend, user receives email)
      // 2. Frontend receives DID token after user clicks link
      // 3. Backend receives DID token from frontend and verifies it
      // For demo, assume DID token is passed as 'password' param
      final didToken = password; // In real use, this is the DID token
      if (didToken.isEmpty) {
        throw DSAuthError('DID token is required for Magic sign-in');
      }
      // 4. Verify DID token with Magic API
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

  /// Signs out the current user and cleans up sessions
  ///
  /// Throws [DSAuthError] if sign-out fails
  @override
  Future<void> signOut() async {
    try {
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

  /// Creates a new user account (for Magic, this is just sign-in)
  ///
  /// [email] - User's email address
  /// [password] - Magic DID token (from frontend)
  /// [displayName] - Optional display name
  /// Throws [DSAuthError] if account creation fails
  @override
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    // Magic is passwordless; account is created on first sign-in
    await signIn(email, password);
  }

  /// Gets the current authenticated user
  ///
  /// Returns [DSAuthUser] if signed in, otherwise throws [DSAuthError]
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

  /// Retrieves a user by their ID
  ///
  /// [userId] - The unique identifier of the user
  /// Throws [UnimplementedError] as Magic does not support direct lookup
  @override
  Future<DSAuthUser> getUser(String userId) async {
    // Magic does not provide direct user lookup by ID via public API
    // You may need to store user info in your DB after sign-in
    throw UnimplementedError(
      'getUser is not supported by Magic API. Store user info after sign-in.',
    );
  }

  /// Verifies the validity of an authentication token
  ///
  /// [token] - The DID token to verify (optional, defaults to current)
  /// Returns true if valid, false otherwise
  @override
  Future<bool> verifyToken([String? token]) async {
    final didToken = token ?? _currentDIDToken;
    if (didToken == null) return false;
    final userInfo = await _verifyDIDTokenWithMagic(didToken);
    return userInfo != null;
  }

  /// Refreshes an authentication token
  ///
  /// [refreshToken] - Not supported for Magic
  /// Throws [UnimplementedError]
  @override
  Future<String> refreshToken(String refreshToken) async {
    // Magic tokens are short-lived; refresh by re-authenticating
    // You may need to trigger a new login from the frontend
    throw UnimplementedError(
      'Magic tokens cannot be refreshed; re-authenticate instead.',
    );
  }

  /// Handles successful login events
  ///
  /// [user] - The authenticated user information
  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    // Optionally, handle post-login actions
  }

  /// Handles successful logout events
  @override
  Future<void> onLogout() async {
    // Optionally, handle post-logout actions
  }

  /// Helper: Verify DID token with Magic API
  ///
  /// [didToken] - The DID token to verify
  /// Returns user info map if valid, otherwise null
  Future<Map<String, dynamic>?> _verifyDIDTokenWithMagic(
    String didToken,
  ) async {
    // See: https://docs.magic.link/reference/api-verifymagictoken
    final url = Uri.parse('https://api.magic.link/v1/admin/auth/user/get');
    final response = await http.post(
      url,
      headers: {
        'X-Magic-Secret-key': secretKey,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $didToken',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? data;
    }
    return null;
  }

  /// Generates a unique device identifier for session management
  String _generateDeviceId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
