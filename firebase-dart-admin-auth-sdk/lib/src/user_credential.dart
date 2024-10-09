import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/additional_user_info.dart';

class UserCredential {
  final User user;
  final AdditionalUserInfo? additionalUserInfo;
  final AuthCredential? credential;
  final String? operationType;

  UserCredential({
    required this.user,
    this.additionalUserInfo,
    this.credential,
    this.operationType,
  });

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    AuthCredential? credential;
    if (json['credential'] != null) {
      final credentialData = json['credential'] as Map<String, dynamic>;
      final providerId = credentialData['providerId'] as String;

      switch (providerId) {
        case 'password':
          credential = EmailAuthCredential(
            email: credentialData['email'],
            password: credentialData['password'],
          );
          break;
        case 'phone':
          credential = PhoneAuthCredential(
            verificationId: credentialData['verificationId'],
            smsCode: credentialData['smsCode'],
          );
          break;
        default:
          credential = OAuthCredential(
            providerId: providerId,
            accessToken: credentialData['accessToken'],
            idToken: credentialData['idToken'],
          );
      }
    }

    return UserCredential(
      user: User.fromJson(json),
      additionalUserInfo: json['additionalUserInfo'] != null
          ? AdditionalUserInfo.fromJson(json['additionalUserInfo'])
          : null,
      credential: credential,
      operationType: json['operationType'],
    );
  }

  get providerId => null;
}
