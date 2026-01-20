class User {
  final String id;
  final String email;
  final String provider;

  User({
    required this.id,
    required this.email,
    required this.provider,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      provider: json['provider'],
    );
  }
}
