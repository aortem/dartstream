class User {
  final String uid;
  final String email;
  final bool emailVerified;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;

  User({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['localId'],
      email: json['email'],
      emailVerified: json['emailVerified'] ?? false,
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      photoURL: json['photoUrl'],
    );
  }
}
