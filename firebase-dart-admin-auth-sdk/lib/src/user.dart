import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/provider_user_info.dart';
import 'id_token_result_model.dart';

/// Represents a user object that contains all the necessary information
/// related to a user in Firebase Authentication.
///
/// This class contains the user's details, authentication tokens, and metadata
/// related to the user's account, such as email verification, phone number,
/// and additional provider-specific information.
class User {
  /// Unique identifier for the user.
  final String uid;

  /// The user's email address.
  String? email;

  /// Whether the user's email is verified.
  bool? emailVerified;

  /// The user's phone number.
  String? phoneNumber;

  /// The user's display name.
  String? displayName;

  /// URL to the user's photo.
  String? photoURL;

  /// The authentication ID token for the user.
  String? idToken;

  /// Expiration time for the ID token.
  DateTime? _idTokenExpiration;

  /// The user's refresh token.
  String? refreshToken;

  /// A list of provider-specific information related to the user.
  List<ProviderUserInfo>? providerUserInfo;

  /// The time the user's password was last updated.
  DateTime? passwordUpdatedAt;

  /// The time from which the user's credentials are valid.
  DateTime? validSince;

  /// Whether the user account is disabled.
  bool? disabled;

  /// The time the user last logged in.
  DateTime? lastLoginAt;

  /// The time the user's account was created.
  DateTime? createdAt;

  /// Custom attributes associated with the user.
  Map<String, dynamic>? customAttributes;

  /// Whether the user is enrolled in multi-factor authentication (MFA).
  final bool mfaEnabled;

  /// The tenant ID for the user.
  String? tenantId;

  /// Creates an instance of the [User] class with the given parameters.
  ///
  /// The constructor initializes the user's details, authentication tokens,
  /// and metadata.
  User({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.refreshToken,
    this.createdAt,
    this.customAttributes,
    this.disabled,
    this.lastLoginAt,
    this.passwordUpdatedAt,
    this.providerUserInfo,
    this.validSince,
    this.mfaEnabled = false,
    this.idToken,
    this.tenantId,
  });

  /// A getter to determine if the user is signed in anonymously.
  ///
  /// This returns `true` if both the email and phone number are null,
  /// indicating an anonymous sign-in, otherwise it returns `false`.
  bool get isAnonymous => email == null && phoneNumber == null;

  /// Returns the current ID token, refreshing it if necessary.
  ///
  /// If the `forceRefresh` flag is set to `true` or if the token is expired
  /// or null, this method will refresh the ID token and return the new token.
  /// This method simulates a token refresh process and updates the expiration time.
  Future<String> getIdToken([bool forceRefresh = false]) async {
    if (forceRefresh || idToken == null || _idTokenExpiration == null) {
      // Simulate a token refresh process
      idToken = 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
      _idTokenExpiration = DateTime.now().add(Duration(hours: 1));
    }
    return idToken!;
  }

  /// Updates the user's ID token and refresh token.

  void updateIdToken(String newToken) {
    idToken = newToken;
    _idTokenExpiration = DateTime.now().add(Duration(hours: 1));
    refreshToken = newToken;
  }

  /// Converts the [User] instance to a map for easy serialization.
  ///
  /// This method is useful for converting the user object into a format
  /// suitable for API responses or database storage.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
      'refreshToken': refreshToken,
      'mfaEnabled': mfaEnabled,
    };
  }

  /// Factory constructor to create a [User] instance from a JSON object.
  ///
  /// This is useful for parsing JSON responses from Firebase or other services.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['localId'] ?? json['uid'],
      email: json['email'],
      emailVerified: json['emailVerified'] ?? false,
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      photoURL: json['photoUrl'] ?? json['photoURL'],
      mfaEnabled: json['mfaEnabled'] ?? false,
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
      tenantId: json['tenantId'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime?.fromMillisecondsSinceEpoch(
              int.tryParse(json['createdAt'].toString()) ?? 0,
            ),
      customAttributes: json['customAttributes'] == null
          ? null
          : jsonDecode(json['customAttributes']),
      disabled: json['disabled'],
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime?.fromMillisecondsSinceEpoch(
              int.tryParse(json['lastLoginAt'].toString()) ?? 0,
            ),
      passwordUpdatedAt: json['passwordUpdatedAt'] == null
          ? null
          : DateTime?.fromMillisecondsSinceEpoch(
              int.tryParse(json['passwordUpdatedAt'].toString()) ?? 0,
            ),
      providerUserInfo: json['providerUserInfo'] == null
          ? null
          : json['providerUserInfo'] != null
          ? (json['providerUserInfo'] as List)
                .map((e) => ProviderUserInfo.fromJson(e))
                .toList()
          : null,
      validSince: json['validSince'] == null
          ? null
          : DateTime?.fromMillisecondsSinceEpoch(
              int.tryParse(json['validSince'].toString()) ?? 0,
            ),
    );
  }

  /// Creates a copy of the [User] instance with optional updates to fields.
  ///
  /// This method allows you to create a new [User] object with some updated
  /// values while keeping the unchanged fields from the original instance.
  User copyWith(User user) {
    return User(
      uid: user.uid,
      displayName: user.displayName ?? displayName,
      email: user.email ?? email,
      emailVerified: user.emailVerified ?? emailVerified,
      idToken: user.idToken ?? idToken,
      phoneNumber: user.phoneNumber ?? phoneNumber,
      photoURL: user.photoURL ?? photoURL,
      refreshToken: user.refreshToken ?? refreshToken,
      createdAt: user.createdAt ?? createdAt,
      customAttributes: user.customAttributes ?? customAttributes,
      disabled: user.disabled ?? disabled,
      lastLoginAt: user.lastLoginAt ?? lastLoginAt,
      passwordUpdatedAt: user.passwordUpdatedAt ?? passwordUpdatedAt,
      providerUserInfo: user.providerUserInfo ?? providerUserInfo,
      validSince: user.validSince ?? validSince,
    );
  }

  /// Returns a string representation of the [User] object.
  ///
  /// This is useful for debugging and logging purposes.
  @override
  String toString() {
    return 'User{uid: $uid, email: $email, emailVerified: $emailVerified, phoneNumber: $phoneNumber, displayName: $displayName, photoURL: $photoURL, _idToken: $idToken, _idTokenExpiration: $_idTokenExpiration}';
  }

  /// Returns an [IdTokenResult] containing the token information.
  ///
  /// This method fetches the ID token and returns the associated information
  /// such as token expiration time and issuance time.
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    final token = await getIdToken(forceRefresh);
    return IdTokenResult(
      token: token,
      expirationTime: _idTokenExpiration?.millisecondsSinceEpoch ?? 0,
      issuedAtTime: DateTime.now().millisecondsSinceEpoch,
      signInProvider: 'password', // or 'phone' or '(link unavailable)' etc.
      userId: uid,
      authTime: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Implements equality based on the user’s fields.
  ///
  /// This method compares two [User] objects based on their field values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.email == email &&
        other.emailVerified == emailVerified &&
        other.phoneNumber == phoneNumber &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.idToken == idToken &&
        other._idTokenExpiration == _idTokenExpiration;
  }

  /// Computes a hash code for the [User] object based on its fields.
  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        emailVerified.hashCode ^
        phoneNumber.hashCode ^
        displayName.hashCode ^
        photoURL.hashCode ^
        idToken.hashCode ^
        _idTokenExpiration.hashCode;
  }

  ///provider data

  get providerData => null;
}
