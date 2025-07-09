// Common Interface for all Auth Providers

/// Interface for all Auth Providers
abstract class DSAuthProvider {
  /// Initializes the provider with configuration settings
  Future<void> initialize(Map<String, dynamic> config);

  /// Signs in a user with the given credentials
  Future<void> signIn(String username, String password);

  /// Signs out the current user
  Future<void> signOut();

  /// Retrieves a user by their ID
  Future<DSAuthUser> getUser(String userId);

  /// Retrieves the current user's token
  Future<bool> verifyToken([String? token]);

  /// Refreshes the current user's token
  Future<String> refreshToken(String refreshToken);

  /// Retrieves the currently authenticated user
  Future<DSAuthUser> getCurrentUser();

  /// Creates a new user account with the given credentials
  Future<void> createAccount(
    String email,
    String password, {
    String? displayName,
  });

  /// Lifecycle hooks
  Future<void> onLoginSuccess(DSAuthUser user) async {}

  /// Lifecycle hooks
  Future<void> onLogout() async {}
}

/// Standardized User model for consistent structure across providers
class DSAuthUser {
  /// Unique user ID
  final String id;

  /// User's email address
  final String email;

  /// User's display name
  final String displayName;

  /// Custom attributes for user
  final Map<String, dynamic>? customAttributes;

  /// Creates a new user instance
  DSAuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.customAttributes,
  });
}

/// Custom exception for handling errors in authentication
class DSAuthError implements Exception {
  /// Error message
  final String message;

  /// Optional error code
  final int? code;

  /// Creates a new Auth Error
  DSAuthError(this.message, {this.code});

  @override
  String toString() => 'DSAuthError: $message (Code: $code)';
}
