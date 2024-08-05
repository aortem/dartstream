class User {
  final String uid;
  final String? email;
  final bool emailVerified;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  String? _idToken;
  DateTime? _idTokenExpiration;
  String? refreshToken;
  final bool mfaEnabled;

  User({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.refreshToken,
    this.mfaEnabled = false,
  });

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

  void updateIdToken(String newToken) {
    _idToken = newToken;
    _idTokenExpiration = DateTime.now().add(Duration(hours: 1));
    refreshToken = newToken;
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
      'refreshToken': refreshToken,
      'mfaEnabled': mfaEnabled,
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
      refreshToken: json['refreshToken'],
      mfaEnabled: json['mfaEnabled'] ?? false,
    );
  }
}
