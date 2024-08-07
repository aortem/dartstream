//added emailVerified and phoneNumber fields
//added isAnonymous getter to determine if the user is signed in anonymously
//Added getIdToken method for token management
//added toMap method for easy serialization

class User {
  final String uid;
  String? email;
  bool? emailVerified;
  String? phoneNumber;
  String? displayName;
  String? photoURL;
  String? idToken;
  String? idTokenExpiration;
  String? refreshToken;

  User({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.idToken,
    this.idTokenExpiration,
    this.refreshToken,
  });

  bool get isAnonymous => email == null && phoneNumber == null;

  Future<String> getIdToken([bool forceRefresh = false]) async {
    if (forceRefresh || idToken == null || idTokenExpiration == null) {
      // In a real implementation, make an API call to refresh the token here
      // For this, just simulate a token refresh
      idToken = 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
      // _idTokenExpiration = DateTime.now().add(Duration(hours: 1));
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
      idTokenExpiration: json['expiresIn'],
      refreshToken: json['refreshToken'],
    );
  }

  User copyWith(User user) {
    return User(
      uid: user.uid,
      displayName: user.displayName ?? displayName,
      email: user.email ?? email,
      emailVerified: user.emailVerified ?? emailVerified,
      idToken: user.idToken ?? idToken,
      idTokenExpiration: user.idTokenExpiration ?? idTokenExpiration,
      phoneNumber: user.phoneNumber ?? user.phoneNumber,
      photoURL: user.photoURL ?? user.photoURL,
      refreshToken: user.refreshToken ?? refreshToken,
    );
  }
}
