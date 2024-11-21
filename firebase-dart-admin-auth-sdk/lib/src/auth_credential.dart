/// An abstract base class representing the credentials required for
/// authentication with various providers (e.g., email/password, phone, OAuth).
abstract class AuthCredential {
  /// The identifier for the authentication provider (e.g., 'password', 'phone').
  final String providerId;

  /// Constructs an instance of [AuthCredential].
  ///
  /// Parameters:
  /// - [providerId]: The identifier for the specific provider.
  AuthCredential(this.providerId);
}

/// Represents email and password authentication credentials.
class EmailAuthCredential extends AuthCredential {
  /// The user's email address used for authentication.
  final String email;

  /// The user's password used for authentication.
  final String password;

  /// Constructs an instance of [EmailAuthCredential].
  ///
  /// Parameters:
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  ///
  /// Sets the [providerId] to 'password'.
  EmailAuthCredential({required this.email, required this.password})
      : super('password');
}

/// Represents phone-based authentication credentials.
class PhoneAuthCredential extends AuthCredential {
  /// The verification ID received during the phone authentication process.
  final String verificationId;

  /// The SMS code received for verification.
  final String smsCode;

  /// Constructs an instance of [PhoneAuthCredential].
  ///
  /// Parameters:
  /// - [verificationId]: The verification ID provided by the phone provider.
  /// - [smsCode]: The SMS code for verification.
  ///
  /// Sets the [providerId] to 'phone'.
  PhoneAuthCredential({required this.verificationId, required this.smsCode})
      : super('phone');
}

/// Represents OAuth authentication credentials, typically used for third-party
/// providers such as Google, Facebook, or GitHub.
class OAuthCredential extends AuthCredential {
  /// An optional access token for authenticating with the provider.
  final String? accessToken;

  /// An optional ID token for authentication (used in some OAuth flows).
  final String? idToken;

  /// The sign-in method used for authentication (e.g., 'password', 'phone').
  final String? signInMethod;

  /// Constructs an instance of [OAuthCredential].
  ///
  /// Parameters:
  /// - [providerId]: The provider's identifier (e.g., 'google.com', 'facebook.com').
  /// - [accessToken]: An optional access token for authentication.
  /// - [idToken]: An optional ID token for authentication.
  OAuthCredential({
    required String providerId,
    this.accessToken,
    this.idToken,
    this.signInMethod,
  }) : super(providerId);
}
