import 'user.dart';

/// Represents the credentials of a user, typically after successful authentication.
///
/// This class contains information about the authenticated user, along with additional
/// user information and the associated credentials.
class UserCredential {
  /// The [User] object containing the user's details.
  final User user;

  /// Additional user information that might be provided during authentication.
  /// This is an optional field that could contain extra details like user metadata.
  final String? additionalUserInfo;

  /// The credential associated with the user, which can be a token or other
  /// credential type depending on the authentication method.
  final String? credential;

  /// Creates an instance of [UserCredential].
  ///
  /// The constructor allows you to initialize a [UserCredential] with the provided
  /// [user], [additionalUserInfo], and [credential]. The [additionalUserInfo] and
  /// [credential] parameters are optional.
  ///
  /// Example usage:
  /// ```dart
  /// UserCredential userCredential = UserCredential(
  ///   user: User(...),
  ///   additionalUserInfo: "some additional info",
  ///   credential: "some credential string",
  /// );
  /// ```
  UserCredential({
    required this.user,
    this.additionalUserInfo,
    this.credential,
  });

  /// Creates a [UserCredential] instance from a JSON map.
  ///
  /// This factory constructor takes a [Map<String, dynamic>] (usually from a decoded
  /// JSON response) and returns a [UserCredential] instance. It is useful for parsing
  /// JSON data received from an authentication provider.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> jsonData = {
  ///   'user': {...}, // User data
  ///   'additionalUserInfo': 'some additional info',
  ///   'credential': 'some credential string'
  /// };
  /// UserCredential userCredential = UserCredential.fromJson(jsonData);
  /// ```
  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      user: User.fromJson(
          json), // Assumes `User.fromJson` is defined in the 'user.dart' file
      additionalUserInfo: json['additionalUserInfo'],
      credential: json['credential'],
    );
  }
}
