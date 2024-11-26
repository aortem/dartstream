library;

/// A class representing the result of an ID token for a Firebase user.
///
/// This class encapsulates information about the ID token, including its
/// expiration time, issuance time, the sign-in provider, user ID, and the
/// authentication time. It is typically used to manage the user's authentication
/// and token metadata in Firebase Authentication.
///
/// **Fields**:

class IdTokenResult {
  /// - token: The ID token as a string. This token is used for authentication.
  final String token;

  /// - [expirationTime]: The expiration time of the token, represented as a Unix timestamp (milliseconds).
  final int expirationTime;

  /// - [issuedAtTime]: The time when the token was issued, represented as a Unix timestamp (milliseconds).
  final int issuedAtTime;

  /// - [signInProvider]: The provider used to sign in (e.g., "password", "google", etc.).
  final String signInProvider;

  /// - [userId]: The unique identifier for the authenticated user.
  final String userId;

  /// - [authTime]: The time at which the user do authentication.
  final String authTime;

  /// Constructs an instance of [IdTokenResult] with the given parameters.
  ///
  /// **Parameters**:
  /// - [token]: The ID token.
  /// - [expirationTime]: The expiration time of the token.
  /// - [issuedAtTime]: The time when the token was issued.
  /// - [signInProvider]: The provider used to sign in.
  /// - [userId]: The unique ID of the user.
  /// - [authTime]: The authentication time of the user.
  IdTokenResult({
    required this.token,
    required this.expirationTime,
    required this.issuedAtTime,
    required this.signInProvider,
    required this.userId,
    required this.authTime,
  });

  /// Returns a string representation of the [IdTokenResult] object.
  ///
  /// This method overrides the `toString` method to provide a human-readable
  /// format of the [IdTokenResult] instance.
  ///
  /// **Returns**:
  /// - A string representation of the [IdTokenResult] object.
  @override
  String toString() {
    return 'IdTokenResult{token: $token, expirationTime: $expirationTime, issuedAtTime: $issuedAtTime, signInProvider: $signInProvider, userId: $userId, authTime: $authTime}';
  }

  /// Creates an instance of [IdTokenResult] from a JSON map.
  ///
  /// This factory constructor allows you to deserialize a JSON object into
  /// an [IdTokenResult] instance.
  ///
  /// **Parameters**:
  /// - [json]: The JSON map containing the token data.
  ///
  /// **Returns**:
  /// - A new instance of [IdTokenResult].
  factory IdTokenResult.fromJson(Map<String, dynamic> json) {
    return IdTokenResult(
      token: json['token'],
      expirationTime: json['expirationTime'],
      issuedAtTime: json['issuedAtTime'],
      signInProvider: json['signInProvider'],
      userId: json['userId'],
      authTime: json['authTime'],
    );
  }
}
