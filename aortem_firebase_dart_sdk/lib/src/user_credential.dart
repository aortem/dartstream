import 'user.dart';

class UserCredential {
  final User user;
  final String? credential;

  UserCredential({required this.user, this.credential});

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      user: User.fromJson(json),
      credential: json['idToken'],
    );
  }
}
