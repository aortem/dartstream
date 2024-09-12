import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/additional_user_info.dart';

class GetRedirectResultService {
  final FirebaseAuth auth;

  GetRedirectResultService({required this.auth});

  Future<UserCredential?> getRedirectResult() async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithIdp',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'returnSecureToken': true,
          'returnIdpCredential': true,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }

      final data = json.decode(response.body);

      if (!data.containsKey('localId')) {
        return null;
      }

      final user = User.fromJson(data);

      final additionalUserInfo = AdditionalUserInfo(
        isNewUser: data['isNewUser'] ?? false,
        providerId: data['providerId'] ?? '',
        profile: data['profile'],
      );

      final credential = OAuthCredential(
        providerId: data['providerId'] ?? '',
        accessToken: data['oauthAccessToken'],
        idToken: data['oauthIdToken'],
      );

      return UserCredential(
        user: user,
        additionalUserInfo: additionalUserInfo,
        credential: credential,
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'get-redirect-result-error',
        message: 'Failed to get redirect result: ${e.toString()}',
      );
    }
  }
}
