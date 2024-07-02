class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['localId'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoUrl'],
    );
  }
}
