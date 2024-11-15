/// An abstract base class representing an authentication provider,
/// used to identify the specific authentication method (e.g., email, phone, OAuth).
abstract class AuthProvider {}

/// Provides an instance of [EmailAuthProvider] for email and password-based
/// authentication.
class EmailAuthProvider extends AuthProvider {
  /// A singleton instance of [EmailAuthProvider].
  static EmailAuthProvider get instance => EmailAuthProvider();
}

/// Provides an instance of [PhoneAuthProvider] for phone-based authentication.
class PhoneAuthProvider extends AuthProvider {
  /// A singleton instance of [PhoneAuthProvider].
  static PhoneAuthProvider get instance => PhoneAuthProvider();
}

/// Provides an instance of [GoogleAuthProvider] for Google OAuth-based authentication.
class GoogleAuthProvider extends AuthProvider {
  /// A singleton instance of [GoogleAuthProvider].
  static GoogleAuthProvider get instance => GoogleAuthProvider();
}

/// Provides an instance of [FacebookAuthProvider] for Facebook OAuth-based authentication.
class FacebookAuthProvider extends AuthProvider {
  /// A singleton instance of [FacebookAuthProvider].
  static FacebookAuthProvider get instance => FacebookAuthProvider();
}
