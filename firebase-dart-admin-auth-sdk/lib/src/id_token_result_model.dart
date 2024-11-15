/// Represents the result of an ID token, typically returned after user authentication.
///
/// This object contains details about the token, its expiration, and other authentication information.
///
/// Example usage:
/// ```dart
/// IdTokenResult result = IdTokenResult.fromJson(jsonResponse);
/// print(result.token); // Access the token
/// ```
class IdTokenResult {
  /// The ID token string.
  final String token;

  /// The expiration time of the ID token, represented as a Unix timestamp (milliseconds since epoch).
  final int expirationTime;

  /// The time when the ID token was issued, represented as a Unix timestamp (milliseconds since epoch).
  final int issuedAtTime;

  /// The sign-in provider used (e.g., 'password', 'google', etc.).
  final String signInProvider;

  /// The unique user ID associated with the token.
  final String userId;

  /// The authentication time, represented as a Unix timestamp (milliseconds since epoch).
  final String authTime;

  /// Creates an instance of [IdTokenResult] with the provided parameters.
  IdTokenResult({
    required this.token,
    required this.expirationTime,
    required this.issuedAtTime,
    required this.signInProvider,
    required this.userId,
    required this.authTime,
  });

  @override
  String toString() {
    return 'IdTokenResult{token: $token, expirationTime: $expirationTime, issuedAtTime: $issuedAtTime, signInProvider: $signInProvider, userId: $userId, authTime: $authTime}';
  }

  /// Creates an instance of [IdTokenResult] from a JSON map.
  /// This method is useful for deserializing the response from an API call.
  ///
  /// Example:
  /// ```dart
  /// IdTokenResult result = IdTokenResult.fromJson(jsonResponse);
  /// ```
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
