import 'user.dart';

class UserCredential {
  final User user;
  final String? additionalUserInfo;
  final String? credential;

  UserCredential({
    required this.user,
    this.additionalUserInfo,
    this.credential,
  });

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      user: User.fromJson(json),
      additionalUserInfo: json['additionalUserInfo'],
      credential: json['credential'],
    );
  }
}
