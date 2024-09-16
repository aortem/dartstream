//added emailVerified and phoneNumber fields
//added isAnonymous getter to determine if the user is signed in anonymously
//Added getIdToken method for token management
//added toMap method for easy serialization
import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/src/provider_user_info.dart';
import 'id_token_result_model.dart';

class User {
  final String uid;
  String? email;
  bool? emailVerified;
  String? phoneNumber;
  String? displayName;
  String? photoURL;
  String? idToken;
  DateTime? _idTokenExpiration;
  String? refreshToken;
  List<ProviderUserInfo>? providerUserInfo;
  DateTime? passwordUpdatedAt;
  DateTime? validSince;
  bool? disabled;
  DateTime? lastLoginAt;
  DateTime? createdAt;
  Map<String, dynamic>? customAttributes;

  User({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.idToken,
    this.refreshToken,
    this.createdAt,
    this.customAttributes,
    this.disabled,
    this.lastLoginAt,
    this.passwordUpdatedAt,
    this.providerUserInfo,
    this.validSince,
  });

  bool get isAnonymous => email == null && phoneNumber == null;

  Future<String> getIdToken([bool forceRefresh = false]) async {
    if (forceRefresh || idToken == null || _idTokenExpiration == null) {
      // In a real implementation, make an API call to refresh the token here
      // For this, just simulate a token refresh
      idToken = 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
      _idTokenExpiration = DateTime.now().add(Duration(hours: 1));
    }
    return idToken!;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['localId'] ?? json['uid'],
      email: json['email'],
      emailVerified: json['emailVerified'] ?? false,
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      photoURL: json['photoUrl'] ?? json['photoURL'],
      idToken: json['idToken'],
      //   idTokenExpiration: json['expiresIn'],
      refreshToken: json['refreshToken'],
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

  User copyWith(User user) {
    return User(
      uid: user.uid,
      displayName: user.displayName ?? displayName,
      email: user.email ?? email,
      emailVerified: user.emailVerified ?? emailVerified,
      idToken: user.idToken ?? idToken,
      // idTokenExpiration: user.idTokenExpiration ?? idTokenExpiration,
      phoneNumber: user.phoneNumber ?? user.phoneNumber,
      photoURL: user.photoURL ?? user.photoURL,
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

  @override
  String toString() {
    return 'User{uid: $uid, email: $email, emailVerified: $emailVerified, phoneNumber: $phoneNumber, displayName: $displayName, photoURL: $photoURL, _idToken: $idToken, _idTokenExpiration: $_idTokenExpiration}';
  }

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

  // Implement value-based equality
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
}
