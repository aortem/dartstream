//added emailVerified and phoneNumber fields
//added isAnonymous getter to determine if the user is signed in anonymously
//Added getIdToken method for token management
//added toMap method for easy serialization

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';

import 'firebase_auth.dart';
import 'id_token_result_model.dart';

class User {
  final String uid;
  final String? email;
  final bool emailVerified;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  String? _idToken;
  DateTime? _idTokenExpiration;

  User({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
  });
  @override
  String toString() {
    return 'User{uid: $uid, email: $email, emailVerified: $emailVerified, phoneNumber: $phoneNumber, displayName: $displayName, photoURL: $photoURL, _idToken: $_idToken, _idTokenExpiration: $_idTokenExpiration}';
  }

  bool get isAnonymous => email == null && phoneNumber == null;

  Future<String> getIdToken([bool forceRefresh = false]) async {
    if (forceRefresh ||
        _idToken == null ||
        _idTokenExpiration == null ||
        DateTime.now().isAfter(_idTokenExpiration!)) {
      // In a real implementation, make an API call to refresh the token here
      // For this, just simulate a token refresh
      _idToken = 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
      _idTokenExpiration = DateTime.now().add(Duration(hours: 1));
    }
    return _idToken!;
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
    );
  }

  Future<void> linkWithCredential(AuthCredential credential) async {
    // final user = await FirebaseApp.instance;
    //   if (user == null) {
    //     throw Exception('No user is signed in');
    //   }
    //   final updatedUser = await user.linkWithCredential(credential);
    //   return User.fromJson(updatedUser.toJson());
    // }
  }
}
