import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

/// Represents the credentials of a user, typically after successful authentication.
///
/// This class contains information about the authenticated user, along with additional
/// user information and the associated credentials.
class UserCredential {
  /// The [User] object containing the user's details.
  final User user;

  /// Additional user information that might be provided during authentication.
  /// This is an optional field that could contain extra details like user metadata.
  final AdditionalUserInfo? additionalUserInfo;

  /// The credential associated with the user, which can be a token or other
  /// credential type depending on the authentication method.
  final AuthCredential? credential;

  /// The type of operation that was performed (e.g., "signIn", "signUp").
  final String? operationType;

  ///provider id
  final String? providerId;

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
    this.operationType,
    this.providerId,
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
    AuthCredential? credential;
    if (json['credential'] != null) {
      final credentialData = json['credential'] as Map<String, dynamic>;
      final providerId = credentialData['providerId'] as String;

      switch (providerId) {
        case 'password':
          credential = EmailAuthCredential(
            email: credentialData['email'],
            password: credentialData['password'],
          );
          break;
        case 'phone':
          credential = PhoneAuthCredential(
            verificationId: credentialData['verificationId'],
            smsCode: credentialData['smsCode'],
          );
          break;
        default:
          credential = OAuthCredential(
            providerId: providerId,
            accessToken: credentialData['accessToken'],
            idToken: credentialData['idToken'],
          );
      }
    }

    return UserCredential(
      user: User.fromJson(
        json,
      ), // Assumes `User.fromJson` is defined in the 'user.dart' file
      additionalUserInfo: json['additionalUserInfo'] != null
          ? AdditionalUserInfo.fromJson(json['additionalUserInfo'])
          : null,
      credential: credential,
      operationType: json['operationType'],
    );
  }

  //get providerId => null;
}
